#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Setter
# ==============================================================================
#  lib/prepare/storage/filesystem/init.sh
#
#  Drives the root filesystem selection menu.
#
#  Does NOT:
#    - Format disks
#    - Create filesystems
#    - Validate installation profile
# ==============================================================================

prepare_filesystem()
{
    case "${AG_P_ROOT_FS:-}" in
        "ext4")
            AG_P_ROOT_FS="btrfs"
            ;;

        "btrfs")
            AG_P_ROOT_FS="ext4"
            ;;

        *)
            AG_P_ROOT_FS="ext4"
            ;;
    esac

    update_swap_for_filesystem

    log_silent \
        "SETTER: filesystem — AG_P_ROOT_FS=${AG_P_ROOT_FS:-}"
}