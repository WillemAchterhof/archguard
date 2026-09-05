#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Login Trigger
# ==============================================================================
#  /etc/profile.d/archguard-postboot.sh
#
#  Starts the one-time ArchGuard post-boot service after the first interactive
#  Bash login. The service itself runs as root; sudo provides the user's
#  interactive authentication prompt.
# ===============================================================================

# Never trigger from root.
[[ "$EUID" -eq 0 ]] && return 0

# Only trigger from an interactive login shell.
[[ "$-" == *i* ]] || return 0

readonly AG_POSTBOOT_RUN="/opt/archguard/postboot/run.sh"
readonly AG_POSTBOOT_SERVICE="archguard-postboot.service"

# Nothing remains after successful first-boot configuration.
[[ -f "$AG_POSTBOOT_RUN" ]] || return 0

# Avoid starting a second copy while the service is already running.
if systemctl is-active --quiet "$AG_POSTBOOT_SERVICE" 2>/dev/null; then
    return 0
fi

printf '\n[ArchGuard] First-boot configuration is pending.\n'
printf '[ArchGuard] Administrative authentication is required.\n\n'

if ! sudo systemctl start "$AG_POSTBOOT_SERVICE"; then
    printf '\n[ArchGuard] WARNING: First-boot configuration did not complete.\n'
    printf '[ArchGuard] It will be retried at the next login.\n\n'
fi