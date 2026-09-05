#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Enrollment
# ==============================================================================
#  lib/postboot/tpm/enroll.sh
# ==============================================================================

set -Eeuo pipefail

# readonly AG_TPM_PCRS="0+1+2+4+5+7+11+12"
readonly AG_TPM_PCRS="11"

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

main()
{
    local luks_device

    luks_device=$(cryptsetup status cryptroot 2>/dev/null |
        awk '/device:/ {print $2}')

    [[ -n "$luks_device" ]] ||
        {
            log "ERROR: Unable to determine LUKS device for cryptroot"
            return 1
        }

    log "Enrolling TPM2 LUKS unlock..."
    log "LUKS device: $luks_device"
    log "PCR policy: $AG_TPM_PCRS"

    systemd-cryptenroll \
        --tpm2-device=auto \
        --tpm2-with-pin=yes \
        --tpm2-pcrs="$AG_TPM_PCRS" \
        "$luks_device"

    log "TPM2 enrollment completed successfully."
}

main "$@"