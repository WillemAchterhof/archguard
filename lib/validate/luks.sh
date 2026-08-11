#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Passphrase Resolution
# ==============================================================================
#  lib/validate/luks.sh
#
#  Resolves the LUKS passphrase — auto-generated or manually typed
#  and confirmed. Whether a method was even chosen is checked earlier,
#  in validate_required.sh's loop (AG_P_LUKS) — this only runs once
#  every other field has already passed, called directly from the
#  tail of run_validation, not from the per-field check list. That
#  keeps it from re-generating (or re-prompting for) a passphrase on
#  every retry loop back to the menu.
#
#  Does NOT display the passphrase — that happens once, later, on the
#  combined passphrase + disk-destruction confirmation screen (the
#  final gate before install), not here.
#
#  Requires:
#    - generate_luks_passphrase  (lib/prepare/storage/luks/generate.sh)
#    - prompt_luks_passphrase    (lib/prepare/storage/luks/prompt.sh)
#
#  Populates:
#    - AGS_LUKS_PASSPHRASE (sensitive — never written to a profile)
#
#  Does NOT:
#    - Check whether AG_P_LUKS is set (see validate_required.sh)
#    - Display the passphrase
#
#  Returns:
#    - 0 if a passphrase was resolved
#    - 1 if manual entry was declined after a mismatch
# ==============================================================================

resolve_luks_passphrase()
{
    case "$AG_P_LUKS" in
        manual)
            prompt_luks_passphrase || return 1
            ;;
        auto|*)
            generate_luks_passphrase
            ;;
    esac

    return 0
}

# Prints the passphrase block only — no clear, no read. Caller controls
# the screen (the final combined gate in run_validation), so this can
# sit above the disk destruction confirmation on one screen.
display_luks_passphrase()
{
    printf "================================================\n"
    printf " LUKS Passphrase\n"
    printf "================================================\n\n"
    printf "  %s\n\n" "$AGS_LUKS_PASSPHRASE"
    printf "================================================\n\n"
    printf " Store this passphrase somewhere safe now.\n"
    printf " It will not be shown again, and it cannot be\n"
    printf " recovered if lost.\n\n"
}
