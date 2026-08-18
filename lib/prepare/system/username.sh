#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Settings
# ==============================================================================
#  lib/prepare/system/username.sh
#
#  Populates:
#    - AG_P_USERNAME
# ==============================================================================

username_format_valid()
{
    [[ "$1" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]
}

prepare_username()
{
    local input

    printf "\n  Username — lowercase letters, numbers, underscore, hyphen.\n"
    printf "  Must start with a lowercase letter or underscore (max 32 chars).\n"
    printf "  Leave blank to cancel.\n\n"

    while true; do
        read -rp "  Enter username [${AG_P_USERNAME:-user}]: " input

        [[ "$input" == "z" ]] && return

        input="${input:-${AG_P_USERNAME:-user}}"

        if ! username_format_valid "$input"; then
            printf "\n  ⚠  Invalid username — lowercase letters, numbers, _ and - only,\n"
            printf "     must start with a letter or underscore.\n\n"
            continue
        fi

        break
    done

    AG_P_USERNAME="$input"
    log_silent "SETTER: username — AG_P_USERNAME=$AG_P_USERNAME"

    set_user_password
}