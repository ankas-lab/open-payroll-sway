library;

pub enum InitError {
    CannotReinitialize: (),
    NotInitialized: (),
}

pub enum OpenPayrollError {
    /// The caller is not the owner of the contract
    NotOwner: (),
    /// The caller is not the proposed owner
    NotProposedOwner: (),
    /// The contract is paused
    ContractIsPaused: (),
    /// The params are invalid
    InvalidParams: (),
    /// The account is not found
    AccountNotFound: (),
    /// The contract does not have enough balance to pay
    NotEnoughBalanceInTreasury: (),
    /// The transfer failed
    TransferFailed: (),
    /// The beneficiary has no unclaimed payments
    NoUnclaimedPayments: (),
    /// Some of the beneficiaries have unclaimed payments
    PaymentsNotUpToDate: (),
    /// Not all the payments are claimed in the last period
    NotAllClaimedInPeriod: (),
    /// The amount to claim is bigger than the available amount
    ClaimedAmountIsBiggerThanAvailable: (),
    /// The amount of multipliers per Beneficiary is not equal to the amount of base multipliers
    InvalidMultipliersLength: (),
    /// The multiplier id does not exist
    MultiplierNotFound: (),
    /// The multiplier is already deactivated
    MultiplierAlreadyDeactivated: (),
    /// The multiplier is not deactivated
    MultiplierNotDeactivated: (),
    /// There are duplicated multipliers
    DuplicatedMultipliers: (),
    /// There are duplicated beneficiaries
    DuplicatedBeneficiaries: (),
    /// The multiplier is not expired yet
    MultiplierNotExpired: (),
    /// The maximum number of beneficiaries is exceeded
    MaxBeneficiariesExceeded: (),
    /// The maximum number of multipliers is exceeded
    MaxMultipliersExceeded: (),
    /// The beneficiary already exists
    AccountAlreadyExists: (),
    /// The multiplier ID overflowed
    MultiplierIdOverflow: (),
}
