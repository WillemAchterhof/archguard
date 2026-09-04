#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Enrollment Verification
# ==============================================================================
#  lib/postboot/tpm/verify.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_TPM_PCRS="0+1+2+4+5+7+11+12"

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

main()
{
    log "Verifying TPM2 enrollment"

    local luks_device

    luks_device=$(cryptsetup status cryptroot 2>/dev/null |
        awk '/device:/ {print $2}')

    if [[ -z "$luks_device" ]]; then
        log "ERROR: Unable to determine LUKS device for cryptroot"
        return 1
    fi

    log "LUKS device: $luks_device"

    if ! cryptsetup isLuks "$luks_device" 2>/dev/null; then
        log "ERROR: Device is not a valid LUKS volume"
        return 1
    fi

    if ! cryptsetup luksDump "$luks_device" 2>/dev/null |
        grep -q 'systemd-tpm2'; then

        log "ERROR: TPM2 enrollment was not found"
        return 1
    fi

    log "TPM2 enrollment found"
    log "Expected PCR policy: $AG_TPM_PCRS"
    log "TPM2 enrollment verification completed"
}

main "$@"