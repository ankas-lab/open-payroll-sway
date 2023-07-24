library;

use std::u128::U128;

pub type Balance = U128;
pub type BlockNumber = U128;
pub type Multipler = U128;
pub type MultiplierId = u32;
pub type MultplierString = str[7];

pub struct Beneficiary {
    account_id: Identity,
    multipliers: StorageMap<u32, Multipler>,
    unclaimed_payments: Balance,
    last_updated_period_block: BlockNumber,
}

/// Claims in period structure containing the period and the total claims
pub struct ClaimsInPeriod {
    period: u32,
    total_claims: u32,
}

/// Base multiplier structure containg a name and an option block number for being used when deactivating the multiplier
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
