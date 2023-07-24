contract;

mod data_structures;
mod interface;
mod errors;

use interface::OpenPayroll;
use errors::*;




use std::storage::storage_vec::*;
use ::data_structures::*;

use std::u128::U128;
use std::constants::{
        ZERO_B256,
    };


storage {
    /// The account to be transfered to, until the new owner accept it
        proposed_owner: Option<Address> = None,
        /// The accountId of the creator of the contract, who has 'priviliged' access to do administrative tasks
        owner: Identity = Identity::ContractId(ContractId::from(ZERO_B256)),
        /// Mapping from the accountId to the beneficiary information
        beneficiaries: StorageMap<Address, Beneficiary> = StorageMap {},
        /// Vector of Accounts
        beneficiaries_accounts: StorageVec<Address> = StorageVec {},
        /// The payment periodicity in blocks
        periodicity: u32 = 0,
        /// The amount of each base payment
        base_payment: Balance = U128::from((0,0)),
        /// The initial block number
        initial_block: u32 = 0,
        /// The block number when the contract was paused
        paused_block_at: Option<u32> = None,
        /// The id of the next multiplier to be added
        next_multiplier_id: MultiplierId = 0,
        /// The multipliers to apply to the base payment
        base_multipliers: StorageMap<MultiplierId, BaseMultiplier> = StorageMap {} ,
        /// A list of the multipliers_ids
        multipliers_list: StorageVec<MultiplierId> = StorageVec {},
        /// Current claims in period
        claims_in_period: ClaimsInPeriod = ClaimsInPeriod { period:0, total_claims:0 },
        // Initialice contract
        state: State = State::Uninitialized,
}

impl OpenPayroll for Contract {
    #[storage(read, write)]
    fn constructor(
            periodicity: u32,
            base_payment: Balance,
            initial_base_multipliers: StorageVec<MultplierString>,
            initial_beneficiaries: StorageVec<Address>,
        ) {
            require(storage.state.read() == State::Uninitialized, InitError::CannotReinitialize);
            storage.state.write(State::Initialized);
    }
}
