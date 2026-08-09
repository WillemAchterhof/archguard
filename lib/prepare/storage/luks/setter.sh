#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Key Method Setter
# ==============================================================================
#  lib/prepare/storage/lvm_luks/setter.sh
#
#  LVM-on-LUKS is mandatory — this only toggles HOW the key will be
#  obtained (auto-generated vs. manually typed), never whether
#  encryption happens. The passphrase itself is never generated or
#  requested here — only at install time (see resolve_luks_passphrase).
#
#  Populates:
#    - AG_P_LUKS ("auto" | "manual")
# ==============================================================================

prepare_luks()
{
    case "${AG_P_LUKS:-}" in
        "manual")
            AG_P_LUKS="auto"
            msg "LUKS key method: auto-generated at install."
            ;;

        "auto")
            AG_P_LUKS="manual"
            msg "LUKS key method: manual entry at install."
            ;;

        *)
            AG_P_LUKS="auto"
            ;;
    esac

    log_silent "SETTER: luks — AG_P_LUKS=${AG_P_LUKS:-}"
}