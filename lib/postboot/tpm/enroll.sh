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

    log "Enrolling TPM2 LUKS unlock..."
    log "PCR policy: $AG_TPM_PCRS"

    systemd-cryptenroll \
        --unlock-key-file="$luks_key" \
        --tpm2-device=auto \
        --tpm2-with-pin=yes \
        --tpm2-pcrs="$AG_TPM_PCRS" \
        /dev/mapper/cryptroot

    unset luks_key

    log "TPM2 enrollment completed successfully."
}

main "$@"