#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Enrollment
# ==============================================================================
#  lib/postboot/tpm/enroll.sh
# ===============================================================================

set -Eeuo pipefail

readonly AG_LUKS_KEY="/opt/archguard/luks.key"
readonly AG_TPM_PCRS="0+1+2+4+5+7+11+12"

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

get_luks_device()
{
    local device

    device="$(cryptsetup status cryptroot 2>/dev/null | awk '/device:/ {print $2; exit}')"

    [[ -n "$device" ]] \
        || {
            log "ERROR: Unable to determine LUKS device for cryptroot"
            return 1
        }

    printf '%s\n' "$device"
}

main()
{
    local luks_device

    [[ -f "$AG_LUKS_KEY" ]] \
        || {
            log "ERROR: Temporary LUKS key not found: $AG_LUKS_KEY"
            return 1
        }

    luks_device="$(get_luks_device)"

    log "LUKS device: $luks_device"
    log "PCR policy: $AG_TPM_PCRS"
    log "Enrolling TPM2 with mandatory PIN"
    log "systemd-cryptenroll will prompt for the TPM PIN"

    systemd-cryptenroll \
        --unlock-key-file="$AG_LUKS_KEY" \
        --tpm2-device=auto \
        --tpm2-with-pin=yes \
        --tpm2-pcrs="$AG_TPM_PCRS" \
        "$luks_device"

    log "TPM2 enrollment completed"
}

main "$@"