#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Keyboard Setter
# ==============================================================================
#  lib/prepare/system/keyboard.sh
#
#  Substring search against the real, live localectl keymap list
#  (not a guessed pattern) — type part of a keyboard layout, get a
#  numbered list back if more than one match, exact auto-accept if
#  only one.
#
#  Blank input leaves the existing AG_P_KEYMAP unchanged.
#
#  A final keymap-list check is performed immediately before committing,
#  as a belt-and-suspenders confirmation.
#
#  Populates:
#    - AG_P_KEYMAP
# ==============================================================================

prepare_keyboard()
{
    local query
    local input
    local choice
    local selected
    local -a matches
    local i

    printf "\n  Keyboard — type part of a layout or keymap (e.g. 'us' or\n"
    printf "  'uk'), at least 2 characters. Leave blank to skip.\n\n"

    while true; do
        read -rp "  Search keyboard [${AG_P_KEYMAP:-us}]: " query

        [[ "$query" == "z" ]] && return

        # Blank = skip/cancel, leaving the existing value untouched.
        if [[ -z "$query" ]]; then
            return
        fi

        if [[ "${#query}" -lt 2 ]]; then
            printf "\n  ⚠  Type at least 2 characters to search.\n\n"
            continue
        fi

        # Search the real, live keymap list.
        #
        # awk is used instead of grep so that "no matches" does not return
        # status 1 and trip set -Eeuo pipefail.
        mapfile -t matches < <(
            localectl list-keymaps |
                awk -v q="$query" '
                    index(tolower($0), tolower(q))
                '
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

    # Final confirmation against the live keymap list immediately before
    # committing the value.
    if ! localectl list-keymaps |
        awk -v q="$input" '
            $0 == q {
                found = 1
            }

            END {
                exit !found
            }
        '
    then
        printf "\n  ⚠  Not a recognized keyboard keymap: %s\n\n" "$input"
        return 1
    fi

    AG_P_KEYMAP="$input"
    log_silent "SETTER: keyboard — AG_P_KEYMAP=$AG_P_KEYMAP"
}