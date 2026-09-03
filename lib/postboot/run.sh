#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Runner
# ==============================================================================
#  lib/postboot/run.sh
# ==============================================================================

set -Eeuo pipefail

readonly AG_POSTBOOT_DIR="/opt/archguard/postboot"
readonly AG_POSTBOOT_SERVICE="archguard-postboot.service"

log()
{
    printf '[ArchGuard PostBoot] %s\n' "$*"
}

cleanup()
{
    log "Post-boot configuration completed"

    systemctl disable "$AG_POSTBOOT_SERVICE" 2>/dev/null || true
    rm -f -- "/etc/systemd/system/$AG_POSTBOOT_SERVICE"
    systemctl daemon-reload

    rm -rf -- "$AG_POSTBOOT_DIR"

    # Remove ArchGuard directory if it is now empty
    rmdir -- /opt/archguard 2>/dev/null || true

    log "Post-boot service removed"
}

main()
{
    log "Starting post-boot configuration"

    for script in "$AG_POSTBOOT_DIR"/*.sh; do
        [[ -f "$script" ]] || continue
        [[ "$script" == "$AG_POSTBOOT_DIR/run.sh" ]] && continue

        log "Running: $(basename "$script")"
        bash "$script"
    done

    cleanup
}

main "$@"