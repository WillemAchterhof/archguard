#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Enrollment
# ==============================================================================
#  lib/postboot/tpm/enroll.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_TPM_PCRS="0+1+2+4+5+7+11+12"

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

main()
{
    local luks_key="${1:-}"
    local tpm_pin
    local tpm_pin_confirm

    [[ -n "$luks_key" ]] \
        || {
            log "ERROR: LUKS key path was not provided"
            return 1
        }

    [[ -f "$luks_key" ]] \
        || {
            log "ERROR: LUKS key not found: $luks_key"
            return 1
        }

    log "TPM enrollment requires a PIN."
    printf '\n'

    while true; do
        read -r -s -p "Enter TPM PIN: " tpm_pin
        printf '\n'

        read -r -s -p "Confirm TPM PIN: " tpm_pin_confirm
        printf '\n'

        if [[ -z "$tpm_pin" ]]; then
            log "ERROR: TPM PIN cannot be empty."
            continue
        fi

        if [[ "$tpm_pin" != "$tpm_pin_confirm" ]]; then
            log "ERROR: TPM PINs do not match."
            continue
        fi

        break
    done

    log "Enrolling TPM2 LUKS unlock..."
    log "PCR policy: $AG_TPM_PCRS"

    systemd-cryptenroll \
        --unlock-key-file="$luks_key" \
        --tpm2-device=auto \
        --tpm2-with-pin=yes \
        --tpm2-pcrs="$AG_TPM_PCRS" \
        /dev/mapper/cryptroot

    unset tpm_pin
    unset tpm_pin_confirm
    unset luks_key

    log "TPM2 enrollment completed successfully."
}

main "$@"