#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Profile Save
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_save.sh
#
#  Writes current AG_BTRFS_* values to a profile's btrfs_config.env.
#
#  Does NOT:
#    - Decide which profile or path to write to
#    - Create directories
# ==============================================================================

save_btrfs_profile()
{
    local file="$1"

    {
        declare -p \
            AG_BTRFS_LAYOUT \
            AG_BTRFS_COMPRESSION \
            AG_BTRFS_SNAPSHOTS \
            AG_BTRFS_COW \
            AG_BTRFS_SUBVOLUMES
    } | sed 's/^declare -/declare -g -/' > "$file"

    chmod 600 "$file"
}