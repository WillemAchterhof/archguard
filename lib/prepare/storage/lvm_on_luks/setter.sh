#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Key Method Setter
# ==============================================================================
#  lib/prepare/storage/lvm_on_luks/setter.sh
#
#  LVM-on-LUKS is mandatory — this only toggles HOW the key is
#  obtained (auto-generated vs. manually typed), never whether
#  encryption happens.
#
#  Requires:
#    - generate_luks_passphrase (from generate.sh)
#
#  Populates:
#    - AG_P_LUKS ("auto" | "manual")
#    - AGS_LUKS_PASSPHRASE (sensitive)
# ==============================================================================

prepare_lvm_luks()
{
    case "${AG_P_LUKS:-}" in
        ""|"manual")
            generate_luks_passphrase
            AG_P_LUKS="auto"
            msg "LUKS passphrase auto-generated."
            ;;

        "auto")
            if prompt_luks_passphrase; then
                AG_P_LUKS="manual"
                msg "LUKS passphrase set manually."
            fi
            ;;

        *)
            generate_luks_passphrase
            AG_P_LUKS="auto"
            ;;
    esac

    log_silent "SETTER: luks — AG_P_LUKS=${AG_P_LUKS:-}"
}

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