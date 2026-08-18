#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Locale Setter
# ==============================================================================
#  lib/prepare/system/locale.sh
#
#  Substring search against the real /etc/locale.gen locale definitions.
#
#  Both enabled and commented locale definitions are searchable.
#
#  Type part of a language, region, or locale:
#    - One match  -> automatically accepted
#    - Multiple  -> numbered selection
#    - No matches -> search again or blank to skip
#
#  Blank input leaves the existing AG_P_LOCALE unchanged.
#  'z' cancels the setter entirely.
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

    printf "\n  Locale — type part of a language or locale (e.g. 'en_' for\n"
    printf "  en_US.UTF-8), at least 3 characters. Leave blank to skip.\n\n"

    while true; do
        read -rp "  Search locale [${AG_P_LOCALE:-C.UTF-8}]: " query

        [[ "$query" == "z" ]] && return

        # Blank = skip, leaving the existing value untouched.
        if [[ -z "$query" ]]; then
            return
        fi

        if [[ "${#query}" -lt 3 ]]; then
            printf "\n  ⚠  Type at least 3 characters to search.\n\n"
            continue
        fi

        # ----------------------------------------------------------------------
        # Search /etc/locale.gen.
        #
        # Examples:
        #
        #   #en_US.UTF-8 UTF-8
        #   en_US.UTF-8 UTF-8
        #
        # Both are treated as:
        #
        #   en_US.UTF-8
        #
        # awk is used so a search with zero results does not trigger
        # set -Eeuo pipefail.
        # ----------------------------------------------------------------------

        mapfile -t matches < <(
            awk -v q="$query" '
                {
                    line = $0

                    # Remove leading whitespace.
                    sub(/^[[:space:]]+/, "", line)

                    # First field is the locale.
                    locale = $1

                    # /etc/locale.gen uses # to disable a locale.
                    # The # is NOT part of the locale name.
                    sub(/^#/, "", locale)

                    if (locale == "")
                        next

                    if (index(tolower(locale), tolower(q)) > 0)
                        print locale
                }
            ' /etc/locale.gen
        )

        # ----------------------------------------------------------------------
        # Nothing found
        # ----------------------------------------------------------------------

        if [[ "${#matches[@]}" -eq 0 ]]; then
            printf "\n  ⚠  Nothing found for: %s\n" "$query"
            printf "  Enter another search, or leave blank to skip.\n\n"
            continue
        fi

        # ----------------------------------------------------------------------
        # Remove duplicates while preserving order.
        # ----------------------------------------------------------------------

        mapfile -t matches < <(
            printf '%s\n' "${matches[@]}" |
                awk '!seen[$0]++'
        )

        # ----------------------------------------------------------------------
        # Exactly one result.
        # ----------------------------------------------------------------------

        if [[ "${#matches[@]}" -eq 1 ]]; then
            input="${matches[0]}"
            break
        fi

        # ----------------------------------------------------------------------
        # Multiple results.
        # ----------------------------------------------------------------------

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

    # --------------------------------------------------------------------------
    # Final confirmation.
    #
    # Check that the selected locale actually exists as a definition in
    # /etc/locale.gen.
    # --------------------------------------------------------------------------
    
    if ! awk -v q="$input" '
        {
            line = $0
            sub(/^[[:space:]]+/, "", line)

            locale = $1
            sub(/^#/, "", locale)

            if (locale == q) {
                found = 1
                exit
            }
        }

        END {
            exit !found
        }
    ' /etc/locale.gen
    then
        printf "\n  ⚠  Not a recognized locale: %s\n\n" "$input"
        return 1
    fi

    # --------------------------------------------------------------------------
    # Commit
    # --------------------------------------------------------------------------

    AG_P_LOCALE="$input"

    log_silent "SETTER: locale — AG_P_LOCALE=$AG_P_LOCALE"
}