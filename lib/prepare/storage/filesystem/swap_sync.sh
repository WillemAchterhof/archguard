#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Consistency
# ==============================================================================
#  lib/prepare/storage/filesystem/swap_sync.sh
#
#  Keeps swap configuration consistent when the root filesystem changes.
#
#  Depends on swap_file_allowed()/get_swap_status() from storage/swap/ —
#  safe by construction: AG_P_SWAP_ENABLED can only be "file" if the
#  swap module has already run and set it, so swap's functions are
#  guaranteed loaded before this ever needs to call them.
# ==============================================================================

update_swap_for_filesystem()
{
    if [[ "$AG_P_SWAP_ENABLED" == "file" ]] && ! swap_file_allowed; then
        AG_P_SWAP_ENABLED="partition"

        get_swap_status

        msg "Swap changed to partition (swap files are unsupported on btrfs)."
    fi
}