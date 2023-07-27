contract;

mod data_structures;
mod interface;
mod errors;
mod constants;
mod utils;
mod events;

use interface::OpenPayroll;
use errors::*;
use utils::*;
use events::*;

use std::storage::storage_vec::*;
use ::data_structures::*;
use ::constants::*;
use std::{
    auth::msg_sender,
    block::height,
    call_frames::contract_id,
    call_frames::msg_asset_id,
    context::{
        msg_amount,
        this_balance,
    },
    token::transfer,
};

use std::{constants::{BASE_ASSET_ID, ZERO_B256}, u128::U128};

storage {
    /// The account to be transfered to, until the new owner accept it
    proposed_owner: Option<Identity> = None,
    /// The accountId of the creator of the contract, who has 'priviliged' access to do administrative tasks
    owner: Identity = Identity::ContractId(ContractId::from(ZERO_B256)),
    /// Mapping from the accountId to the beneficiary information
    beneficiaries: StorageMap<Identity, Beneficiary> = StorageMap {},
    /// Vector of Accounts
    beneficiaries_accounts: StorageVec<Identity> = StorageVec {},
    /// The payment periodicity in blocks
    periodicity: u32 = 0,
    /// The amount of each base payment
    base_payment: Balance = 0,
    /// The initial block number
    initial_block: u32 = 0,
    /// The block number when the contract was paused
    paused_block_at: Option<u32> = None,
    /// Current claims in period
    claims_in_period: ClaimsInPeriod = ClaimsInPeriod {
        period: 0,
        total_claims: 0,
    },
    // Initialice contract
    state: State = State::Uninitialized,
}

impl OpenPayroll for Contract {
    #[storage(read, write)]
    fn constructor(
        periodicity: u32,
        base_payment: Balance,
        initial_beneficiaries: Vec<Identity>,
    ) {
        require(storage.state.read() == State::Uninitialized, InitError::CannotReinitialize);
        require(periodicity > 0, OpenPayrollError::InvalidParams);
        require(base_payment > 0, OpenPayrollError::InvalidParams);
        require(initial_beneficiaries.len() <= MAX_BENEFICIARIES, OpenPayrollError::MaxBeneficiariesExceeded);
        require(msg_sender().is_ok(), OpenPayrollError::InvalidParams);

        storage.state.write(State::Initialized);
        storage.periodicity.write(periodicity);
        storage.base_payment.write(base_payment);
        storage.initial_block.write(height());
        storage.owner.write(msg_sender().unwrap());

        // vec to vecstorage for beneficiaries
        let mut i = 0;
        while i < initial_beneficiaries.len() {
            let address = initial_beneficiaries.get(i).unwrap();

            storage.beneficiaries_accounts.push(address);
            storage.beneficiaries.insert(address, Beneficiary {
                account_id: address,
                unclaimed_payments: 0,
                last_updated_period_block: 0,
                multiplier: DEFAULT_MULTIPLIER,
            });
            i += 1;
        }
    }

    #[storage(read, write)]
    fn claim_payment(account_id: Identity, amount: Balance) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_is_not_pause(storage.paused_block_at.read()), OpenPayrollError::ContractIsPaused);
        let beneficiary_res = storage.beneficiaries.get(account_id).try_read();

        require(beneficiary_res.is_some(), OpenPayrollError::AccountNotFound);
        let mut beneficiary = beneficiary_res.unwrap();

        let current_block = height();

        // check the asset Id is the same
        require(msg_asset_id() == BASE_ASSET_ID, OpenPayrollError::TransferFailed);
        require(amount > 0, OpenPayrollError::TransferFailed);

        // TODO: If there are deactivated multipliers, remove them from the beneficiary
        let total_payment = 0; // TODO: calculate total payment  
        require(amount <= total_payment, OpenPayrollError::ClaimedAmountIsBiggerThanAvailable);

        let treasury_balance = this_balance(contract_id());
        require(treasury_balance >= amount, OpenPayrollError::NotEnoughBalanceInTreasury);

        // let claiming_period_block = self.get_current_period_initial_block(); // TODO: implement
        let claiming_period_block = 0; // TODO: implement
        beneficiary.unclaimed_payments = total_payment - amount;
        beneficiary.last_updated_period_block = claiming_period_block;
        storage.beneficiaries.insert(account_id, beneficiary);

        transfer(amount, BASE_ASSET_ID, account_id);

        // Emit Event
        log(Claimed {
            account_id: account_id,
            amount: amount,
            asset_id: BASE_ASSET_ID,
            total_payment: total_payment,
            claiming_period_block: claiming_period_block,
        });
    }

    #[storage(read, write)]
    fn pause() {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);

        if storage.paused_block_at.read().is_none() {
            storage.paused_block_at.write(Some(height()));
            log(Paused {});
        }
    }

    #[storage(read, write)]
    fn resume() {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);

        if storage.paused_block_at.read().is_some() {
            storage.paused_block_at.write(None);
            log(Resumed {});
        }
    }

    #[storage(read, write)]
    fn propose_transfer_ownership(new_owner: Identity) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);
        storage.proposed_owner.write(Some(new_owner));

        log(OwnershipProposed {
            current_owner: storage.owner.read(),
            proposed_owner: new_owner,
        });
    }

    #[storage(read, write)]
    fn accept_ownership() {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(storage.proposed_owner.read().unwrap() == msg_sender().unwrap(), OpenPayrollError::NotProposedOwner);

        let old_owner = storage.owner.read();
        storage.proposed_owner.write(None);

        log(OwnershipAccepted {
            previous_owner: old_owner,
            new_owner: storage.owner.read(),
        });
    }

    #[storage(read, write)]
    fn add_beneficiary(account_id: Identity, multiplier: Multiplier) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        //self.ensure_beneficiary_to_add(account_id, &multipliers)?; //TODO: implement
        storage.beneficiaries.insert(account_id, Beneficiary {
            account_id: account_id,
            unclaimed_payments: 0,
            last_updated_period_block: 0,
            multiplier: multiplier,
            last_updated_period_block: 0, // TODO: implement self.get_current_period_initial_block(),
        });
    }

    #[storage(read, write)]
    fn update_beneficiary(account_id: Identity, multiplier: Multiplier) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);

        // Ensure that the beneficiary exists
        require(storage.beneficiaries.get(account_id).try_read().is_some(), OpenPayrollError::AccountNotFound);

        // TODO: implement
        // calculate the amount to claim to be transferred to the uncleared payments
        // let unclaimed_payments = self._get_amount_to_claim(account_id, false);

        storage.beneficiaries.insert(account_id, Beneficiary {
            account_id: account_id,
            unclaimed_payments: 0,
            last_updated_period_block: 0,
            multiplier: multiplier,
        });

        log(BeneficiaryUpdated {
            account_id: account_id,
            multiplier: multiplier,
        });
    }

    #[storage(read, write)]
    fn remove_beneficiary(account_id: Identity) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);

        // Ensure that the beneficiary exists
        require(storage.beneficiaries.get(account_id).try_read().is_some(), OpenPayrollError::AccountNotFound);

        storage.beneficiaries.remove(account_id);

        // Delete a account from a storageVec without retain
        let mut index = 0;
        while index < storage.beneficiaries_accounts.len() {
            if account_id == storage.beneficiaries_accounts.get(index).unwrap().read()
            {
                storage.beneficiaries_accounts.swap_remove(index);
                break;
            }
            index += 1;
        }

        log(BeneficiaryRemoved {
            account_id: account_id,
        });
    }

    #[storage(read, write)]
    fn update_base_payment(base_payment: Balance) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);
        require(base_payment > 0, OpenPayrollError::InvalidParams);

        storage.base_payment.write(base_payment);
    }

    #[storage(read, write)]
    fn update_periodicity(periodicity: u32) {
        require(ensure_is_initialized(storage.state.read()), InitError::NotInitialized);
        require(ensure_owner(storage.owner.read()), OpenPayrollError::NotOwner);
        require(periodicity > 0, OpenPayrollError::InvalidParams);

        storage.periodicity.write(periodicity);
    }

    #[storage(read)]
    fn is_paused() -> bool {
        storage.paused_block_at.read().is_some()
    }

    #[storage(read)]
    fn get_owner() -> Identity {
        storage.owner.read()
    }

    #[storage(read)]
    fn get_amount_to_claim(account_id: Identity) -> Option<Balance> {
        let beneficiary_res = storage.beneficiaries.get(account_id).try_read();
        if beneficiary_res.is_none() {
            return None;
        }
        let beneficiary = beneficiary_res.unwrap();
        let block = height();
        // Calculates the number of blocks that have elapsed since the last payment
        let blocks_since_last_payment = block - beneficiary.last_updated_period_block;

        // Calculates the number of periods that are due based on the elapsed blocks
        let unclaimed_periods: u64 = blocks_since_last_payment / storage.periodicity.read();

        // If there's no unclaimed periods, return the unclaimed payments
        // Otherwise, calculate the amount to claim and add the unclaimed payments
        if unclaimed_periods == 0 {
            Some(beneficiary.unclaimed_payments)
        } else {
            let payment_per_period =
                get_amount_to_claim_for_one_period(beneficiary, storage.base_payment.read());

            Some(payment_per_period * unclaimed_periods + beneficiary.unclaimed_payments)
        }
    }

        #[storage(read)]
    fn get_beneficiary(account_id: Identity) -> Option<Beneficiary>{
        storage.beneficiaries.get(account_id).try_read()
    }
}
