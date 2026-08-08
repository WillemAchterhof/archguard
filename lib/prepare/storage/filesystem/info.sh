#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Info
# ==============================================================================
#  lib/prepare/storage/filesystem/info.sh
#
#  Requires:
#    - render_btrfs_menu (from btrfs_render.sh)
# ==============================================================================

show_filesystem_info()
{
    clear
    printf "\
================================================
 Root Filesystem
================================================
  ext4    Stable, mature, widely supported. No
          built-in snapshots or subvolumes.

  btrfs   Snapshots, compression, subvolumes.
          Current configuration shown below.
"

    if [[ "$AG_P_ROOT_FS" == "btrfs" ]]; then
        render_btrfs_menu
    fi

    printf "\n Press any key to return..."
    read -r -n1 -s
    printf "\n"
}