#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Key Method Setter
# ==============================================================================
#  lib/prepare/storage/lvm_luks/setter.sh
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

prepare_luks()
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