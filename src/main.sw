contract;

mod interface;
use interface::MyContract;
use std::storage::storage_vec::*;

use std::u128::U128;
use std::constants::{
        ZERO_B256,
    };

type Balance = U128;
type BlockNumber = U128;
type Multipler = U128;
type MultiplierId = u32;
type MultplierString = str[7];

pub struct Beneficiary {
    account_id: Identity,
    multipliers: StorageMap<u32, Multipler>,
    unclaimed_payments: Balance,
    last_updated_period_block: BlockNumber,
}

pub struct ClaimsInPeriod {
    period: u32,
    total_claims: u32,
}

pub struct BaseMultiplier {
    name: MultplierString,
    valid_until_block: Option<BlockNumber>,
}
impl BaseMultiplier {
    pub fn new(name: MultplierString) -> Self {
        Self {
            name,
            valid_until_block: None,
        }
    }
}

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
        claims_in_period: ClaimsInPeriod = ClaimsInPeriod { period:0, total_claims:0},
}



impl MyContract for Contract {
    fn test_function() -> bool {
        true
    }
}
