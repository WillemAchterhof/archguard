#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — EFI Setter
# ==============================================================================
#  lib/prepare/storage/efi/init.sh
#
#  Drives the EFI partition size selection.
#
#  Does NOT:
#    - Format partitions
#    - Validate installation profile
# ==============================================================================

prepare_efi()
{
    case "${AG_P_EFI_SIZE:-}" in
        "300M")
            AG_P_EFI_SIZE="500M"
            ;;

        "500M")
            AG_P_EFI_SIZE="1G"
            ;;

        "1G")
            AG_P_EFI_SIZE="300M"
            ;;

        *)
            AG_P_EFI_SIZE="500M"
            ;;
    esac

    log_silent \
        "SETTER: efi — AG_P_EFI_SIZE=${AG_P_EFI_SIZE:-}"
}