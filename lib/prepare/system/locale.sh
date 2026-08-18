#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Locale Setter
# ==============================================================================
#  lib/prepare/system/locale.sh
#
#  Substring search against the real, live localectl locale list
#  (not a guessed pattern) — type part of a locale, get a numbered list back
#  if more than one match, exact auto-accept if only one.
#
#  Falls back to the existing AG_P_LOCALE when the user skips.
#
#  A final locale-list check is performed immediately before committing,
#  as a belt-and-suspenders confirmation.
#
#  Populates:
#    - AG_P_LOCALE
# ==============================================================================

prepare_locale()
{
    local query
    local input
    local choice
    local selected
    local -a matches
    local i

    printf "\n  Locale — type part of a language or locale (e.g. 'en_us' for\n"
    printf "  en_US.UTF-8), at least 3 characters. Leave blank to skip.\n\n"

    while true; do
        read -rp "  Search locale [${AG_P_LOCALE:-C.UTF-8}]: " query

        [[ "$query" == "z" ]] && return

        # Blank = skip/cancel, leaving the existing value untouched.
        if [[ -z "$query" ]]; then
            return
        fi

        if [[ "${#query}" -lt 3 ]]; then
            printf "\n  ⚠  Type at least 3 characters to search.\n\n"
            continue
        fi

        # awk is used instead of grep so that "no matches" does not
        # return exit status 1 and trip set -Eeuo pipefail.
        mapfile -t matches < <(
            localectl list-locales |
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

        # Separate inner loop: keep re-prompting for a selection from THIS
        # list until valid, blank (search again), or z (cancel entirely).
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

    # Final confirmation against the live locale list immediately before
    # committing the value.
    if ! localectl list-locales |
        awk -v q="$input" '$0 == q { found=1 } END { exit !found }'
    then
        printf "\n  ⚠  Not a recognized locale: %s\n\n" "$input"
        return 1
    fi

    AG_P_LOCALE="$input"
    log_silent "SETTER: locale — AG_P_LOCALE=$AG_P_LOCALE"
}