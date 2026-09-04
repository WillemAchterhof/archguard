#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Runner
# ==============================================================================
#  lib/postboot/run.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_POSTBOOT_DIR="/opt/archguard/postboot"
readonly AG_POSTBOOT_SERVICE="archguard-postboot.service"
readonly AG_LUKS_KEY="/opt/archguard/luks.key"

log()
{
    printf '[ArchGuard PostBoot] %s\n' "$*"
}

run_tpm()
{
    log "Running TPM post-boot enrollment"

    "$AG_POSTBOOT_DIR/tpm/run.sh" "$AG_LUKS_KEY"

    log "TPM post-boot enrollment completed"
}

run_usbguard()
{
    log "Running USBGuard post-boot configuration"

    "$AG_POSTBOOT_DIR/usbguard/run.sh"

    log "USBGuard post-boot configuration completed"
}

cleanup()
{
    log "Post-boot configuration completed"

    systemctl disable "$AG_POSTBOOT_SERVICE" 2>/dev/null || true
    rm -f -- "/etc/systemd/system/$AG_POSTBOOT_SERVICE"
    systemctl daemon-reload

    rm -f -- "$AG_LUKS_KEY"
    rm -rf -- "$AG_POSTBOOT_DIR"

    # Remove ArchGuard directory if it is now empty
    rmdir -- /opt/archguard 2>/dev/null || true

    log "Temporary post-boot infrastructure removed"
}

main()
{
    log "Starting post-boot configuration"

    run_tpm

    # Future post-boot subsystems:
    # run_usbguard
    # run_system
    # run_security

    cleanup
}

main "$@"