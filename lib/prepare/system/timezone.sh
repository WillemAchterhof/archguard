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
    local -a matches
    local i

    printf "\n  Timezone — type part of a region or city (e.g. 'amst' for\n"
    printf "  Europe/Amsterdam), at least 3 characters. Leave blank to cancel.\n\n"

    while true; do
        read -rp "  Search timezone [${AG_P_TIMEZONE:-UTC}]: " query

        [[ "$query" == "z" ]] && return

        if [[ -z "$query" ]]; then
            input="${AG_P_TIMEZONE:-UTC}"
            break
        fi

        if [[ "${#query}" -lt 3 ]]; then
            printf "\n  ⚠  Type at least 3 characters to search.\n\n"
            continue
        fi

        mapfile -t matches < <(timedatectl list-timezones | grep -iF "$query")

        if [[ "${#matches[@]}" -eq 0 ]]; then
            printf "\n  ⚠  No timezones match: %s\n\n" "$query"
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

        # Separate inner loop: keep re-prompting for a selection from THIS
        # list until valid, blank (search again), or z (cancel entirely).
        # An invalid number must not fall through to the outer loop, or
        # the next digit typed gets misread as a brand-new search query.
        local selected=""
        while true; do
            read -rp "  Select [1-${#matches[@]}], or blank to search again: " choice

            [[ "$choice" == "z" ]] && return

            if [[ -z "$choice" ]]; then
                break
            fi

            if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#matches[@]} )); then
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