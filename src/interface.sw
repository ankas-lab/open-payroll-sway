library;

use std::u128::U128;
use std::storage::storage_vec::*;
use ::data_structures::*;

abi OpenPayroll {
    #[storage(read, write)]
    fn constructor(periodicity: u32, base_payment: Balance, initial_base_multipliers: StorageVec<MultplierString>, initial_beneficiaries: StorageVec<Address>);
/* 
    #[storage(read, write)]
    fn claim_payment(
            account_id: Address,
            amount: Balance,
        );
    
    #[storage(read, write)]
    fn deactivate_multiplier(multiplier_id: MultiplierId);

    #[storage(read, write)]
    fn delete_unused_multiplier(multiplier_id: MultiplierId);

    #[storage(read, write)]
    fn propose_transfer_ownership(new_owner: Address);

    #[storage(read, write)]
    fn accept_ownership();

    #[storage(read, write)]
    fn add_beneficiary(
            account_id: Address,
            multipliers: StorageVec<(MultiplierId, Multiplier)>,
        );

    #[storage(read, write)]
    fn update_beneficiary(
            account_id: AccountId,
            multipliers: Vec<(MultiplierId, Multiplier)>,
        );
    
    #[storage(read, write)]
    fn remove_beneficiary(account_id: AccountId);

    #[storage(read, write)]
    fn update_base_payment( base_payment: Balance);

    #[storage(read, write)]
    fn add_base_multiplier( name: String); 
    
    #[storage(read, write)]
    fn update_periodicity(&mut self, periodicity: u32)

    #[storage(read, write)]
    fn pause();
    
    #[storage(read, write)]
    fn resume();
    
    // readonly

    // fn ensure_all_payments_uptodate();

    #[storage(read)]
    fn is_paused() -> bool;

    #[storage(read)]
    fn get_amount_to_claim(account_id: Address) -> Option<Balance>;

    #[storage(read)]
    fn get_beneficiary(account_id: Address) -> Option<Beneficiary>;

    #[storage(read)]
    fn get_current_period_initial_block() -> BlockNumber;

    #[storage(read)]
    fn get_next_block_period() -> BlockNumber;

    #[storage(read)]
    fn get_next_block_period() -> BlockNumber;

    #[storage(read)]
    fn get_total_debt_for_next_period() -> Balance;

    #[storage(read)]
    fn get_total_debt_with_unclaimed_for_next_period() -> Balance; 

    #[storage(read)]
    fn get_list_beneficiaries() -> StorageVec<Address>;

    #[storage(read)]
    fn get_contract_balance() -> Balance;

    #[storage(read)]
    fn get_balance_with_debts() -> Balance;    

    #[storage(read)]
    fn get_unclaimed_beneficiaries() -> StorageVec<Address>;

    #[storage(read)]
    fn get_count_of_unclaim_beneficiaries() -> u8;

    #[storage(read)]
    fn get_base_payment() -> Balance;

    #[storage(read)]
    fn get_periodicity() -> BlockNumber;

    #[storage(read)]
    fn get_initial_block() -> BlockNumber;

    #[storage(read)]
    fn get_multipliers_list() -> StorageVec<MultiplierId>;

    #[storage(read)]
    fn get_base_multiplier(multiplier_id: MultiplierId) -> Option<BaseMultiplier>;

    #[storage(read)]
    fn get_owner() -> Address;


    */
}
