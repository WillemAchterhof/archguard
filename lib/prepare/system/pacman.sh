#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman Parallel Downloads Setter
# ==============================================================================
#  lib/prepare/system/pacman.sh
#
#  Sets the number of parallel downloads used by pacman.
#
#  Valid values:
#    1 - 99
#
#  Blank input leaves the existing AG_P_PACMAN_PARALLEL unchanged.
#  'z' cancels the setter entirely.
#
#  Populates:
#    - AG_P_PACMAN_PARALLEL
# ==============================================================================

prepare_pacman()
{
    local input

    printf "\n  Pacman — number of parallel downloads.\n"
    printf "  Enter a value from 1 to 99. Leave blank to skip.\n\n"

    while true; do
        read -rp \
            "  Parallel downloads [${AG_P_PACMAN_PARALLEL:-5}]: " \
            input

        [[ "$input" == "z" ]] && return

        # Blank = skip, leaving the existing value untouched.
        if [[ -z "$input" ]]; then
            return
        fi

        # Numeric input only.
        if ! [[ "$input" =~ ^[0-9]+$ ]]; then
            printf "\n  ⚠  Enter a whole number from 1 to 99.\n\n"
            continue
        fi

        # Range check.
        if (( input < 1 || input > 99 )); then
            printf "\n  ⚠  Parallel downloads must be between 1 and 99.\n\n"
            continue
        fi

        break
    done

    # --------------------------------------------------------------------------
    # Commit
    # --------------------------------------------------------------------------

    AG_P_PACMAN_PARALLEL="$input"

    log_silent \
        "SETTER: pacman parallel downloads — AG_P_PACMAN_PARALLEL=$AG_P_PACMAN_PARALLEL"
}