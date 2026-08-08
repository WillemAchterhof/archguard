#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Passphrase Display
# ==============================================================================
#  lib/prepare/storage/lvm_on_luks/show.sh
# ==============================================================================

show_luks_passphrase()
{
    if [[ -z "${AG_P_LUKS:-}" ]]; then
        printf " No LUKS key method set yet.\n"
        sleep 1
        return
    fi

    printf "\n Passphrase: %s\n" "${AGS_LUKS_PASSPHRASE:-<unavailable>}"
    printf " Press any key to continue..."
    read -r -n1 -s
    printf "\n"
}