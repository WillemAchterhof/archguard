#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Wipe Setter
# ==============================================================================
#  lib/prepare/storage/wipe/init.sh
#
#  Cycles the disk wipe mode used before installation begins.
#
#  Does NOT:
#    - Wipe disks (mode is recorded only; execution happens at install time)
# ==============================================================================

prepare_wipe()
{
    case "${AG_P_DISK_WIPE_MODE:-}" in
        "")
            AG_P_DISK_WIPE_MODE="quick"
            ;;

        "quick")
            AG_P_DISK_WIPE_MODE="secure"
            ;;

        "secure")
            AG_P_DISK_WIPE_MODE="paranoia"
            ;;

        "paranoia")
            AG_P_DISK_WIPE_MODE=""
            ;;

        *)
            AG_P_DISK_WIPE_MODE="quick"
            ;;
    esac

    msg "Disk wipe mode: ${AG_P_DISK_WIPE_MODE:-Not set}"
    log_silent "SETTER: wipe — AG_P_DISK_WIPE_MODE=${AG_P_DISK_WIPE_MODE:-}"
}