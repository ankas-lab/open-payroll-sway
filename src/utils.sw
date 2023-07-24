library;
/* 
fn ensure_owner() -> Result<(), Error> { }

// ensure_is_not_paused ensures that the contract is not paused
fn ensure_is_not_paused() -> Result<(), Error> {}

// Ensure multipliers are valid
fn ensure_multipliers_are_valid(
    multipliers: &[(MultiplierId, Multiplier)],
) -> Result<(), Error> { }

// Function for doing the ensurance before adding a new beneficiary
fn ensure_beneficiary_to_add(
    account_id: AccountId,
    multipliers: &[(MultiplierId, Multiplier)],
) -> Result<(), Error> {
    
}

// Get the amount of tokens that can be claimed by a beneficiary with specific block_numer
fn _get_amount_to_claim_in_block(
    account_id: AccountId,
    filtered_multipliers: bool,
    block: BlockNumber,
) -> Balance {
    
}

// check the amount to claim for one beneficiary in any period
// without unclaimed payments
fn _get_amount_to_claim_for_one_period(
    beneficiary: &Beneficiary,
    filtered_multipliers: bool,
) -> Balance {
}

// internal function to get the amount to claim
// filtered multipliers in true means that all multipliers are active
fn _get_amount_to_claim(
    account_id: AccountId,
    filtered_multipliers: bool,
) -> Balance {
}

// Updates the number of claims in a period
// If the period is the same, it increments the number of claims
// Otherwise, it resets the number of claims and set it to 1
fn _update_claims_in_period(claiming_period_block: BlockNumber) {
    
}

// Ensure if all beneficiaries claimed in period
fn ensure_all_claimed_in_period() -> Result<(), Error> {

} */