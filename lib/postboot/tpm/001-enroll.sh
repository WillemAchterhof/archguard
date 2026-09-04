#!/usr/bin/env bash

tpm_enroll_luks() {
    log_info "[ArchGuard TPM] Enrolling TPM2 LUKS unlock..."

    # Ensure systemd-cryptenroll is available
    if ! command -v systemd-cryptenroll &>/dev/null; then
        log_error "[ArchGuard TPM] systemd-cryptenroll is not installed."
        return 1
    fi

    # Resolve backing LUKS device from mapper name (cryptroot)
    local luks_device
    luks_device=$(cryptsetup status cryptroot 2>/dev/null | awk '/device:/ {print $2}')

    if [[ -z "$luks_device" || ! -b "$luks_device" ]]; then
        log_error "[ArchGuard TPM] Could not determine underlying LUKS block device for cryptroot."
        return 1
    fi

    log_info "[ArchGuard TPM] Target LUKS device detected: $luks_device"

    # Enroll TPM2 PCR policy against the backing block device
    if systemd-cryptenroll --tpm2-device=auto \
                           --tpm2-pcrs=0+1+2+4+5+7+11+12 \
                           "$luks_device"; then
        log_info "[ArchGuard TPM] Successfully enrolled TPM2 key into $luks_device"
    else
        log_error "[ArchGuard TPM] TPM2 enrollment failed for $luks_device"
        return 1
    fi
}

tpm_enroll_luks