#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Settings
# ==============================================================================
#  lib/prepare/system/hostname.sh
#
#  Populates:
#    - AG_P_HOSTNAME
# ==============================================================================

hostname_format_valid()
{
    [[ "$1" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$ ]]
}

prepare_hostname()
{
    local input

    printf "\n  Hostname — letters, numbers and hyphens only (max 63 chars).\n"
    printf "  Leave blank to cancel.\n\n"

    while true; do
        read -rp "  Enter hostname [${AG_P_HOSTNAME:-arch-secure}]: " input

        [[ "$input" == "z" ]] && return

        input="${input:-${AG_P_HOSTNAME:-arch-secure}}"

        if ! hostname_format_valid "$input"; then
            printf "\n  ⚠  Invalid hostname — letters, numbers and hyphens only.\n\n"
            continue
        fi

        break
    done

    AG_P_HOSTNAME="$input"
    log_silent "SETTER: hostname — AG_P_HOSTNAME=$AG_P_HOSTNAME"
}