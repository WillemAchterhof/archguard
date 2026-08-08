#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Defaults Reset
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_defaults.sh
#
#  Resets AG_BTRFS_* back to the installer's shipped defaults by
#  re-sourcing lib/core/variables/btrfs.sh — the single source of
#  truth for default values.
#
#  Requires:
#    - AG_DIR_VARS (from lib/core/variables/module.sh)
# ==============================================================================

reset_btrfs_defaults()
{
    source "$AG_DIR_VARS/btrfs.sh"
}

reset_btrfs_profile()
{
    local file="$AG_DIR_PROFILE_STATE/$AG_PROFILE_NAME/btrfs_config.env"

    if [[ -f "$file" ]]; then
        load_btrfs_profile
    else
        reset_btrfs_defaults
    fi
}