library;

pub fn ensure_is_not_pause(paused_block_at: Option<u32>) -> bool {
    assert(paused_block_at.is_none());
    true
}