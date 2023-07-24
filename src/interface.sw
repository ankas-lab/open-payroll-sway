library;

use std::u128::U128;
use std::storage::storage_vec::*;
use ::data_structures::*;

abi OpenPayroll {
     #[payable, storage(read, write)]
    fn new(
            periodicity: u32,
            base_payment: Balance,
            initial_base_multipliers: StorageVec<MultplierString>,
            initial_beneficiaries: StorageVec<Address>,
        );
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

    fn update_beneficiary(
            account_id: AccountId,
            multipliers: Vec<(MultiplierId, Multiplier)>,
        );
    
    fn remove_beneficiary(account_id: AccountId);

    fn update_base_payment( base_payment: Balance);

    fn add_base_multiplier( name: String); */
}