#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Profile Load
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_profile.sh
#
#  If the current profile has a saved btrfs_config.env, load it,
#  overriding the defaults from lib/core/variables/btrfs.sh. If not,
#  the defaults already in memory are left untouched.
#
#  Requires:
#    - AG_DIR_PROFILE_ROOT, AG_PROFILE_NAME
#
#  Does NOT:
#    - Create profile directories
#    - Save anything
# ==============================================================================

load_btrfs_profile()
{
    local file="$AG_DIR_PROFILE_ROOT/$AG_PROFILE_NAME/btrfs_config.env"

    [[ -f "$file" ]] || return 0

    if ! bash -n "$file" 2>/dev/null; then
        printf " ⚠ Saved btrfs profile has a syntax error — using defaults.\n"
        sleep 2
        return 1
    fi

    source "$file"
}