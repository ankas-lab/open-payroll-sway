library;

use ::data_structures::State;

pub fn ensure_is_not_pause(paused_block_at: Option<u32>) -> bool {
    assert(paused_block_at.is_none());
    true
}

pub fn ensure_owner(owner: Identity) -> bool {
    assert(owner == msg_sender().unwrap());
    true
}

pub fn ensure_is_initialized(state: State) -> bool {
    assert(state == State::Initialized);
    true
}
