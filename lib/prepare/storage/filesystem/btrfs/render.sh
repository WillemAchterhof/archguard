#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Configuration Renderer
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_render.sh
#
#  Requires:
#    - AG_BTRFS_* (from lib/core/variables/btrfs.sh, updated in-memory
#      by edit.sh when the user edits, or by profile.sh on load)
# ==============================================================================

render_btrfs_menu()
{
    local subvol

    clear
    printf "\
================================================
 Root Filesystem
================================================
  ext4    Stable, mature, widely supported. No
          built-in snapshots or subvolumes.

  btrfs   Snapshots, compression, subvolumes.
          Current configuration shown below.

================================================
 Btrfs Configuration
================================================
"
    printf "* Layout        : %s\n" "$AG_BTRFS_LAYOUT"
    printf "* Compression   : %s\n" "$AG_BTRFS_COMPRESSION"
    printf "* Snapshots     : %s\n" "$AG_BTRFS_SNAPSHOTS"
    printf "* CoW           : %s\n" "$AG_BTRFS_COW"
    printf "Subvolumes\n"

    for subvol in "${AG_BTRFS_SUBVOLUMES[@]}"; do
        printf "    %s\n" "$subvol"
    done

    printf "================================================\n"
    printf "[v] Reload Profile Config\n"
    printf "[w] Reload Default Config\n"
    printf "[x] Edit configuration file (nano)\n"
    printf "[y] Edit configuration file (vim)\n"
    printf "[z] Return\n\n"
}