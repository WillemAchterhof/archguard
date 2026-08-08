#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Scratch Editing
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs/edit.sh
#
#  Lets the user free-edit AG_BTRFS_* via an external editor. Changes
#  only affect memory — nothing is written to a profile until
#  profile_save runs.
#
#  Requires:
#    - AG_FILE_BTRFS_SCRATCH (from lib/core/variables/paths.sh)
# ==============================================================================

write_btrfs_scratch()
{
    {
        declare -p \
            AG_BTRFS_LAYOUT \
            AG_BTRFS_COMPRESSION \
            AG_BTRFS_SNAPSHOTS \
            AG_BTRFS_COW \
            AG_BTRFS_SUBVOLUMES
    } | sed 's/^declare -/declare -g -/' > "$AG_FILE_BTRFS_SCRATCH"
}

reload_btrfs_scratch()
{
    if ! bash -n "$AG_FILE_BTRFS_SCRATCH" 2>/dev/null; then
        printf " ⚠ Config file has a syntax error — keeping last known values.\n"
        sleep 2
        return 1
    fi

    source "$AG_FILE_BTRFS_SCRATCH"
}