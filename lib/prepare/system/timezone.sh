#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Timezone Setter
# ==============================================================================
#  lib/prepare/system/timezone.sh
#
#  Substring search against the real, live timedatectl timezone list
#  (not a guessed pattern) — type part of a region or city, get a
#  numbered list back if more than one match, exact auto-accept if
#  only one. Falls back to the existing AG_P_TIMEZONE (or UTC) on
#  blank input. Final /usr/share/zoneinfo/ file check right before
#  committing, as a belt-and-suspenders confirmation.
#
#  Populates:
#    - AG_P_TIMEZONE
# ==============================================================================

prepare_timezone()
{
    local query
    local input
    local choice
    local selected
    local -a matches
    local i

    printf "\n  Timezone — type part of a region or city (e.g. 'amst' for\n"
    printf "  Europe/Amsterdam), at least 3 characters. Leave blank to skip.\n\n"

    while true; do
        read -rp "  Search timezone [${AG_P_TIMEZONE:-UTC}]: " query

        [[ "$query" == "z" ]] && return

        # Blank = skip/cancel, leaving existing value untouched.
        if [[ -z "$query" ]]; then
            return
        fi

        if [[ "${#query}" -lt 3 ]]; then
            printf "\n  ⚠  Type at least 3 characters to search.\n\n"
            continue
        fi

        mapfile -t matches < <(
            timedatectl list-timezones |
                awk -v q="$query" 'index(tolower($0), tolower(q))'
        )

        if [[ "${#matches[@]}" -eq 0 ]]; then
            printf "\n  ⚠  Nothing found for: %s\n" "$query"
            printf "  Enter another search, or leave blank to skip.\n\n"
            continue
        fi

        if [[ "${#matches[@]}" -eq 1 ]]; then
            input="${matches[0]}"
            break
        fi

        printf "\n"
        for i in "${!matches[@]}"; do
            printf "   [%d] %s\n" "$((i + 1))" "${matches[$i]}"
        done
        printf "\n"

        selected=""

        while true; do
            read -rp "  Select [1-${#matches[@]}], or blank to search again: " choice

            [[ "$choice" == "z" ]] && return

            if [[ -z "$choice" ]]; then
                break
            fi

            if ! [[ "$choice" =~ ^[0-9]+$ ]] ||
               (( choice < 1 || choice > ${#matches[@]} )); then
                printf "\n  ⚠  Invalid selection.\n\n"
                continue
            fi

            selected="${matches[$((choice - 1))]}"
            break
        done

        if [[ -n "$selected" ]]; then
            input="$selected"
            break
        fi
    done

    if [[ ! -f "/usr/share/zoneinfo/$input" ]]; then
        printf "\n  ⚠  Not a recognized timezone: %s\n\n" "$input"
        return 1
    fi

    AG_P_TIMEZONE="$input"
    log_silent "SETTER: timezone — AG_P_TIMEZONE=$AG_P_TIMEZONE"
}