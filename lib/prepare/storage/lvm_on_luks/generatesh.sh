#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Passphrase Generation
# ==============================================================================
#  lib/prepare/storage/lvm_on_luks/generate.sh
#
#  Generates a random LUKS passphrase. TPM sealing (if used) happens
#  at install time, not here — this only produces the secret.
#
#  Populates:
#    - AGS_LUKS_PASSPHRASE (sensitive — never written to a profile)
# ==============================================================================

prepare_lvm_luks()
{
    set +o pipefail

    AGS_LUKS_PASSPHRASE="$(
        tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' </dev/urandom |
        head -c 32
    )"

    set -o pipefail

    log_silent "ACTION: generated LUKS passphrase"

    sleep 1
}