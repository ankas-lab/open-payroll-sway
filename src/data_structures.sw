library;

pub type Balance = u64;
pub type BlockNumber = u32;
pub type Multiplier = u64;

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
    multiplier: Multiplier,
    unclaimed_payments: Balance,
    last_updated_period_block: BlockNumber,
}

/// Claims in period structure containing the period and the total claims
pub struct ClaimsInPeriod {
    period: u32,
    total_claims: u32,
}
