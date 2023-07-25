library;

use std::constants::{ZERO_B256};

// Establish the maximum number of beneficiaries and multipliers that can be added to the contract
pub const MAX_BENEFICIARIES: u8 = 100;
pub const MAX_MULTIPLIERS: u8 = 10;
pub const TOKEN_CONTRACT_ID: b256 = ZERO_B256;
/// Token ID of Ether (?)
pub const TOKEN_ID = 0x0000000000000000000000000000000000000000000000000000000000000000;