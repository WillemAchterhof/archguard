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
    readonly AG_LUKS_KEY="/opt/archguard/luks.key"
    # Resolve backing LUKS device from mapper name (cryptroot)
    local luks_device
    luks_device=$(cryptsetup status cryptroot 2>/dev/null | awk '/device:/ {print $2}')

    [[ -n "$AG_LUKS_KEY" ]] \
        || {
            log "ERROR: LUKS key path was not provided"
            return 1
        }

    [[ -f "$AG_LUKS_KEY" ]] \
        || {
            log "ERROR: LUKS key not found: $AG_LUKS_KEY"
            return 1
        }

    log "Enrolling TPM2 LUKS unlock..."
    log "PCR policy: $AG_TPM_PCRS"

    systemd-cryptenroll \
        --unlock-key-file="$AG_LUKS_KEY" \
        --tpm2-device=auto \
        --tpm2-with-pin=yes \
        --tpm2-pcrs="$AG_TPM_PCRS" \
        "$luks_device"

    unset luks_key

    log "TPM2 enrollment completed successfully."
}

main "$@"