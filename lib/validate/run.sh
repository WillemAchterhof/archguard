#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Validation Entry Point
# ==============================================================================
#  lib/validate/run.sh
#
#  Runs the field checks, then — only if every one of them passed —
#  resolves the LUKS passphrase once. Reports pass/fail via
#  AG_MENU_PROCEED only — the retry loop back to the menu lives in
#  run_pipeline (orchestrator/pipeline.sh), so validate never calls
#  run_menu itself and stays independent of the menu module.
#
#  Requires:
#    - validate_required_fields (validate_required.sh)
#    - validate_optional_fields (validate_optional.sh)
#    - validate_volumes         (validate_volumes.sh)
#    - resolve_luks_passphrase  (validate_luks.sh)
#
#  Does NOT:
#    - Call run_menu
#    - Touch disks
# ==============================================================================

run_validation()
{
    local failed=0

    validate_required_fields || failed=1
    validate_optional_fields || failed=1
    validate_volumes         || failed=1

    if [[ "$failed" -eq 1 ]]; then
        printf "\n Fix the items above, then press [y] again.\n\n"
        printf " Press any key to return to the menu...\n"
        read -r -n1 -s
        printf "\n"

        AG_MENU_PROCEED="0"
        return 1
    fi

    msg "Resolve LUKS passphrase"

    if ! resolve_luks_passphrase; then
        fail_check "LUKS passphrase not confirmed"
        AG_MENU_PROCEED="0"
        return 1
    fi

    msg "Validation complete — ready to install."
    return 0
}
