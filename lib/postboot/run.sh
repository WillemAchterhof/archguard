#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Post-Boot Runner
# ==============================================================================
#  lib/postboot/tpm/run.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_TPM_DIR="/opt/archguard/postboot/tpm"
readonly AG_TPM_ENROLL="$AG_TPM_DIR/enroll.sh"
readonly AG_TPM_VERIFY="$AG_TPM_DIR/verify.sh"

log()
{
    printf '[ArchGuard TPM] %s\n' "$*"
}

run_enroll()
{
    local luks_key="$1"

    log "Starting TPM enrollment"

    "$AG_TPM_ENROLL" "$luks_key"

    log "TPM enrollment completed"
}

run_verify()
{
    log "Starting TPM enrollment verification"

    "$AG_TPM_VERIFY"

    log "TPM enrollment verification completed"
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

    [[ -x "$AG_TPM_VERIFY" ]] \
        || {
            log "ERROR: TPM verification script not found: $AG_TPM_VERIFY"
            return 1
        }

    run_enroll "$luks_key"
    run_verify

    unset luks_key

    log "TPM post-boot configuration completed successfully"
}

main "$@"