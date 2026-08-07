#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Selection
# ==============================================================================
#  lib/prepare/storage/filesystem/select.sh
# ==============================================================================

select_filesystem()
{
    case "$1" in
        a|A)
            AG_P_ROOT_FS="ext4"
            ;;
        b|B)
            AG_P_ROOT_FS="btrfs"
            ;;
        *)
            printf " Invalid selection.\n"
            return 1
            ;;
    esac

    msg "Filesystem selected: $AG_P_ROOT_FS"
    log_silent "SETTER: filesystem — AG_P_ROOT_FS=$AG_P_ROOT_FS"
    return 0
}