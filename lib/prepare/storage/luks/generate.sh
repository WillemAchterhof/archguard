#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Passphrase Generation
# ==============================================================================
#  lib/prepare/storage/luks/generate.sh
#
#  Generates a random LUKS passphrase. Called from resolve_luks_passphrase
#  at install time — never called directly from the menu.
#
#  Populates:
#    - AGS_LUKS_PASSPHRASE (sensitive — never written to a profile)
# ==============================================================================

generate_luks_passphrase()
{
    AGS_LUKS_PASSPHRASE="$(
        set +o pipefail
        tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' </dev/urandom | head -c 32
    )"

    log_silent "ACTION: generated LUKS passphrase"
}