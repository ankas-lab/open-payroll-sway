library;

use ::data_structures::*;
use std::storage::storage_vec::*;

/// Emitted when a beneficiary claims their payment
pub struct Claimed {
    account_id: Identity,
    amount: Balance,
    asset_id: AssetId,
    total_payment: Balance,
    claiming_period_block: BlockNumber,
}

/// Emiited when the ownership of the contract is transferred
pub struct OwnershipProposed {
    current_owner: Identity,
    proposed_owner: Identity,
}

/// Emitted when the ownership of the contract is accepted
pub struct OwnershipAccepted {
    previous_owner: Identity,
    new_owner: Identity,
}

/// Emitted when a beneficiary is added
pub struct BeneficiaryAdded {
    account_id: Identity,
    multiplier: Multiplier,
}

/// Emitted when a beneficiary is updated
pub struct BeneficiaryUpdated {
    account_id: Identity,
    multiplier: Multiplier,
}

/// Emitted when a beneficiary is removed
pub struct BeneficiaryRemoved {
    account_id: Identity,
}

/// Emitted when the preiodicity is updated
pub struct PeriodicityUpdated {
    periodicity: u32,
}

/// Emitted when the contract is paused
pub struct Paused {}

/// Emitted when the contract is resumed
pub struct Resumed {}
