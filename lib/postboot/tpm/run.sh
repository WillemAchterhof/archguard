#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Post-Boot Runner
# ==============================================================================
#  lib/postboot/tpm/run.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_TPM_DIR="/opt/archguard/postboot/tpm"
readonly AG_TPM_ENROLL="$AG_TPM_DIR/enroll.sh"

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

    [[ -x "$AG_TPM_ENROLL" ]] \
        || {
            log "ERROR: TPM enrollment script not found: $AG_TPM_ENROLL"
            return 1
        }

    log "Starting TPM enrollment"

    "$AG_TPM_ENROLL" "$luks_key"

    log "TPM enrollment successful"
}

main "$@"