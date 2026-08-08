#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Passphrase Prompt
# ==============================================================================
#  lib/prepare/storage/lvm_luks/prompt.sh
#
#  Interactively prompts for and confirms a manual LUKS passphrase.
#  Called from resolve_luks_passphrase at install time when AG_P_LUKS
#  is "manual" — never called directly from the menu.
#
#  Populates:
#    - AGS_LUKS_PASSPHRASE (sensitive — never written to a profile)
#
#  Returns:
#    - 0 if a passphrase was entered and confirmed
#    - 1 if the user declined to retry after a mismatch
# ==============================================================================

prompt_luks_passphrase()
{
    local pass1
    local pass2
    local retry

    while true; do
        printf "\n Type LUKS Passphrase: "
        read -rs pass1
        printf "\n"

        printf " Confirm LUKS Passphrase: "
        read -rs pass2
        printf "\n"

        if [[ -z "$pass1" ]]; then
            printf " Passphrase cannot be empty.\n"
            sleep 1
            continue
        fi

        if [[ "$pass1" != "$pass2" ]]; then
            printf " Passphrases do not match. Try again? [y/N] "
            read -r -n1 -s retry
            printf "\n"
            [[ "$retry" == "y" || "$retry" == "Y" ]] || return 1
            continue
        fi

        AGS_LUKS_PASSPHRASE="$pass1"
        return 0
    done
}