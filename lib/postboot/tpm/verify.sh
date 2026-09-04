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

    if ! systemd-cryptenroll --dump luks_device | \
        grep -q 'systemd-tpm2'; then

        log "ERROR: TPM2 enrollment was not found"
        return 1
    fi

    log "TPM2 enrollment verified"
}

main "$@"