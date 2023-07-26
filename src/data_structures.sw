library;

pub type Balance = u64;
pub type BlockNumber = u32;
pub type Multiplier = u64;
pub type MultiplierId = u32;
pub type MultplierString = str[7];

pub enum State {
    Initialized: (),
    Uninitialized: (),
}

impl core::ops::Eq for State {
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (State::Initialized, State::Initialized) => true,
            (State::Uninitialized, State::Uninitialized) => true,
            _ => false,
        }
    }
}

pub struct Beneficiary {
    account_id: Identity,
    multipliers: StorageMap<MultiplierId, Multiplier>,
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
