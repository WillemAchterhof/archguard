#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Locale Setter
# ==============================================================================
#  lib/prepare/system/locale.sh
#
#  Substring search against the real /etc/locale.gen locale definitions.
#  Type part of a language, region, or locale, get a numbered list back if
#  more than one match, exact auto-accept if only one.
#
#  Commented locale definitions are included in the search because they are
#  valid locale choices that can be enabled and generated later.
#
#  Blank input leaves the existing AG_P_LOCALE unchanged.
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

        # Blank = skip/cancel, leaving the existing value untouched.
        if [[ -z "$query" ]]; then
            return
        fi

        if [[ "${#query}" -lt 3 ]]; then
            printf "\n  ⚠  Type at least 3 characters to search.\n\n"
            continue
        fi

        # Search ALL locale definitions in /etc/locale.gen.
        #
        # Both enabled:
        #
        #   en_US.UTF-8 UTF-8
        #
        # and disabled:
        #
        #   #en_US.UTF-8 UTF-8
        #
        # entries are valid search candidates.
        #
        # awk is used instead of grep so that "no matches" does not trigger
        # set -Eeuo pipefail.
        mapfile -t matches < <(
            awk -v q="$query" '
                {
                    line = $0

                    # Remove leading whitespace.
                    sub(/^[[:space:]]+/, "", line)

                    # Remove the optional comment marker.
                    sub(/^#[[:space:]]*/, "", line)

                    # Ignore empty lines and non-locale comments.
                    if (line == "" || line !~ /^[A-Za-z_][A-Za-z0-9_+.-]*(\.[A-Za-z0-9_-]+)?(@[A-Za-z0-9_-]+)?[[:space:]]+/)
                        next

                    locale = $1

                    if (index(tolower(locale), tolower(q)))
                        print locale
                }
            ' /etc/locale.gen
        )

        if [[ "${#matches[@]}" -eq 0 ]]; then
            printf "\n  ⚠  Nothing found for: %s\n" "$query"
            printf "  Enter another search, or leave blank to skip.\n\n"
            continue
        fi

        # Remove duplicate locale names while preserving their original order.
        mapfile -t matches < <(
            printf '%s\n' "${matches[@]}" |
                awk '!seen[$0]++'
        )

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

    # Final confirmation against the locale definitions.
    #
    # This confirms that the selected value actually exists in the current
    # /etc/locale.gen, regardless of whether it is currently enabled.
    if ! awk -v q="$input" '
        {
            line = $0

            sub(/^[[:space:]]+/, "", line)
            sub(/^#[[:space:]]*/, "", line)

            if (line == "" || line !~ /^[A-Za-z_][A-Za-z0-9_+.-]*(\.[A-Za-z0-9_-]+)?(@[A-Za-z0-9_-]+)?[[:space:]]+/)
                next

            if ($1 == q)
                found = 1
        }

        END {
            exit !found
        }
    ' /etc/locale.gen
    then
        printf "\n  ⚠  Not a recognized locale: %s\n\n" "$input"
        return 1
    fi

    AG_P_LOCALE="$input"
    log_silent "SETTER: locale — AG_P_LOCALE=$AG_P_LOCALE"
}