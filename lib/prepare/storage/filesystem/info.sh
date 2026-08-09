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
    if [[ "$AG_P_ROOT_FS" == "btrfs" ]]; then
        prepare_btrfs
    else
        show_info "\
================================================
 Root Filesystem
================================================
  ext4    Stable, mature, widely supported. No
          built-in snapshots or subvolumes.

  btrfs   Snapshots, compression, subvolumes.
          Select btrfs to see its configuration
          here."
    fi
}