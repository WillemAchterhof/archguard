#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Enrollment Verification
# ==============================================================================
#  lib/postboot/tpm/verify.sh
# ==============================================================================

set -Eeuo pipefail

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

main()
{
    log "Verifying TPM2 enrollment"

    local luks_device
    luks_device=$(cryptsetup status cryptroot 2>/dev/null | awk '/device:/ {print $2}')

    if [[ -z "$luks_device" ]]; then
        log "ERROR: Unable to determine LUKS device for cryptroot"
        return 1
    fi

    log "LUKS device: $luks_device"

    if ! cryptsetup luksDump "$luks_device" 2>/dev/null | \
        grep -q 'systemd-tpm2'; then

        log "ERROR: TPM2 enrollment was not found"
        return 1
    fi

    log "TPM2 enrollment verified"
}

main "$@"