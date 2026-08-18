#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Settings
# ==============================================================================
#  lib/prepare/system/settings.sh
#
#  All system-setting setters live here in one file: hostname,
#  username, locale, timezone, keyboard, mirror countries, pacman
#  parallel downloads. Each validates immediately at the prompt —
#  loop until valid, "z" cancels — matching every other setter in
#  the codebase (disk, LUKS, wipe mode). Where a real authoritative
#  source exists (the zoneinfo tree, locale.gen, localectl, reflector's
#  country list), that's what gets checked against — never a guessed
#  regex standing in for it.
#
#  Populates:
#    - AG_P_HOSTNAME, AG_P_USERNAME, AG_P_TIMEZONE
#      (AG_P_LOCALE, AG_P_KEYBOARD, AG_P_MIRROR_COUNTRIES,
#       AG_P_PACMAN_PARALLEL still to come)
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
}

prepare_timezone()
{
    local input

    printf "\n  Timezone — e.g. Europe/Amsterdam, America/New_York.\n"
    printf "  Leave blank to cancel.\n\n"

    while true; do
        read -rp "  Enter timezone [${AG_P_TIMEZONE:-UTC}]: " input

        [[ "$input" == "z" ]] && return

        input="${input:-${AG_P_TIMEZONE:-UTC}}"

        if [[ ! -f "/usr/share/zoneinfo/$input" ]]; then
            printf "\n  ⚠  Not a recognized timezone: %s\n\n" "$input"
            continue
        fi

        break
    done

    AG_P_TIMEZONE="$input"
    log_silent "SETTER: timezone — AG_P_TIMEZONE=$AG_P_TIMEZONE"
}