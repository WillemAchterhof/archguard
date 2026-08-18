#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Locale Setter
# ==============================================================================
#  lib/prepare/system/locale.sh
#
#  Substring search against the real /etc/locale.gen locale list.
#  Type part of a language or region, get a numbered list back if more than
#  one match, exact auto-accept if only one.
#
#  Blank input leaves the existing AG_P_LOCALE unchanged.
#  A final generated-locale check is performed immediately before committing.
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
    local locale_name
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

        # Search the actual locale definitions configured in /etc/locale.gen.
        #
        # Ignore:
        #   - blank lines
        #   - comments
        #
        # Return only the locale name (first field), not the character map.
        #
        # awk is used instead of grep so "no matches" is not an error under
        # set -Eeuo pipefail.
        mapfile -t matches < <(
            awk -v q="$query" '
                /^[[:space:]]*#/ { next }
                NF == 0 { next }

                {
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

    # Final check: confirm that the selected locale is actually generated
    # and therefore available on the live system.
    #
    # locale -a can use normalized spellings such as en_US.utf8 while
    # /etc/locale.gen may contain en_US.UTF-8, so compare both forms.
    if ! locale -a |
        awk -v q="$input" '
            function normalize(s) {
                s = tolower(s)
                gsub(/[-_.]/, "", s)
                return s
            }

            normalize($0) == normalize(q) {
                found = 1
            }

            END {
                exit !found
            }
        '
    then
        printf "\n  ⚠  Locale is not currently generated: %s\n" "$input"
        printf "  Run locale-gen before committing this locale.\n\n"
        return 1
    fi

    AG_P_LOCALE="$input"
    log_silent "SETTER: locale — AG_P_LOCALE=$AG_P_LOCALE"
}