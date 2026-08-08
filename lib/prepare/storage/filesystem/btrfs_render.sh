#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Configuration Renderer
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_render.sh
#
#  Requires:
#    - AG_BTRFS_* (from lib/core/variables/btrfs.sh, updated in-memory
#      by edit.sh when the user edits)
# ==============================================================================

render_btrfs_menu()
{
    local subvol

    printf "\n"
    printf "================================================\n"
    printf " Btrfs Configuration\n"
    printf "================================================\n"
    printf "* Layout        : %s\n" "$AG_BTRFS_LAYOUT"
    printf "* Compression   : %s\n" "$AG_BTRFS_COMPRESSION"
    printf "* Snapshots     : %s\n" "$AG_BTRFS_SNAPSHOTS"
    printf "* CoW           : %s\n" "$AG_BTRFS_COW"
    printf "Subvolumes\n"

    for subvol in "${AG_BTRFS_SUBVOLUMES[@]}"; do
        printf "    %s\n" "$subvol"
    done

    printf "================================================\n"
    printf "[x] Edit configuration file (nano)\n"
    printf "[y] Edit configuration file (vim)\n"
    printf "[z] Return\n\n"
}