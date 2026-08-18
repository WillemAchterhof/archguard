#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Settings
# ==============================================================================
#  lib/prepare/system/timezone.sh
#
#  Populates:
#    - AG_P_TIMEZONE
# ==============================================================================

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