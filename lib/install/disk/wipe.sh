#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Wipe
# ==============================================================================
#  lib/install/disk/wipe.sh
#
#  Requires:
#    - AG_P_DISK, AG_P_DISK_WIPE_MODE
# ==============================================================================

install_disk_wipe()
{
    case "$AG_P_DISK_WIPE_MODE" in
        quick)
            msg "Wiping disk (quick): $AG_P_DISK"
            wipefs -a "$AG_P_DISK"
            sgdisk --zap-all "$AG_P_DISK"
            ;;

        secure)
            msg "Wiping disk (secure, 1 pass): $AG_P_DISK"
            dd if=/dev/urandom of="$AG_P_DISK" bs=4M status=progress \
                || true
            wipefs -a "$AG_P_DISK"
            sgdisk --zap-all "$AG_P_DISK"
            ;;

        paranoia)
            local pass
            for pass in 1 2 3; do
                msg "Wiping disk (paranoia, pass $pass/3): $AG_P_DISK"
                dd if=/dev/urandom of="$AG_P_DISK" bs=4M status=progress \
                    || true
            done
            wipefs -a "$AG_P_DISK"
            sgdisk --zap-all "$AG_P_DISK"
            ;;

        *)
            fatal "Unknown wipe mode: $AG_P_DISK_WIPE_MODE"
            ;;
    esac
}