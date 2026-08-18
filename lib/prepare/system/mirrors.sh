#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman Mirror Country Setter
# ==============================================================================
#  lib/prepare/system/mirrors.sh
#
#  Country selection is verified against Arch Linux's live mirror database.
#
#  Examples:
#
#    nl                  -> NL
#    netherlands        -> NL
#    de                  -> DE
#    germany             -> DE
#    nl,de               -> NL,DE
#    nl,germany          -> NL,DE
#
#  Multiple countries may be comma-separated.
#
#  Blank input leaves the existing AG_P_MIRROR_COUNTRIES unchanged.
#  'z' cancels the setter entirely.
#
#  Requires:
#    - curl
#    - python
#
#  Populates:
#    - AG_P_MIRROR_COUNTRIES
# ==============================================================================

prepare_mirrors()
{
    local query
    local input
    local token
    local choice
    local selected
    local code
    local name
    local countries_data
    local -a tokens
    local -a matches
    local -a resolved
    local i
    local failed

    printf "\n  Pacman Mirrors — type part of a country name or code.\n"
    printf "  Multiple countries can be comma-separated (e.g. 'nl,de').\n"
    printf "  Leave blank to skip.\n\n"

    # --------------------------------------------------------------------------
    # Check required tools.
    # --------------------------------------------------------------------------

    if ! command -v curl >/dev/null 2>&1; then
        printf "\n  ⚠  curl is required to query Arch mirror data.\n\n"
        return 1
    fi

    if ! command -v python >/dev/null 2>&1; then
        printf "\n  ⚠  python is required to parse Arch mirror data.\n\n"
        return 1
    fi

    # --------------------------------------------------------------------------
    # Download the current country list from Arch Linux.
    #
    # The mirror status JSON contains country and country_code fields.
    # We extract unique pairs only once per setter invocation.
    # --------------------------------------------------------------------------

    countries_data=$(
        curl -fsSL --connect-timeout 10 --max-time 30 \
            'https://archlinux.org/mirrors/status/json/' |
        python -c '
import json
import sys

data = json.load(sys.stdin)

countries = {}

for mirror in data.get("urls", []):
    country = (mirror.get("country") or "").strip()
    code = (mirror.get("country_code") or "").strip().upper()

    if country and code:
        countries[code] = country

for code in sorted(countries):
    print(f"{code}|{countries[code]}")
'
    ) || {
        printf "\n  ⚠  Could not retrieve Arch Linux mirror data.\n"
        printf "  Check your network connection and try again.\n\n"
        return 1
    }

    if [[ -z "$countries_data" ]]; then
        printf "\n  ⚠  Arch Linux returned no country data.\n\n"
        return 1
    fi

    # --------------------------------------------------------------------------
    # Search loop.
    # --------------------------------------------------------------------------

    while true; do
        read -rp \
            "  Mirror countries [${AG_P_MIRROR_COUNTRIES:-Not set}]: " \
            query

        [[ "$query" == "z" ]] && return

        # Blank = skip.
        if [[ -z "$query" ]]; then
            return
        fi

        IFS=',' read -ra tokens <<< "$query"

        resolved=()
        failed=0

        # ----------------------------------------------------------------------
        # Resolve each comma-separated country.
        # ----------------------------------------------------------------------

        for token in "${tokens[@]}"; do

            # Trim leading whitespace.
            token="${token#"${token%%[![:space:]]*}"}"

            # Trim trailing whitespace.
            token="${token%"${token##*[![:space:]]}"}"

            if [[ -z "$token" ]]; then
                printf "\n  ⚠  Empty country entry.\n"
                printf "  Example: nl,de\n\n"
                failed=1
                break
            fi

            matches=()

            # ------------------------------------------------------------------
            # Search by:
            #
            #   ISO code
            #   country name
            #
            # Case-insensitive substring.
            # ------------------------------------------------------------------

            while IFS='|' read -r code name; do

                if [[ "${code,,}" == *"${token,,}"* ||
                      "${name,,}" == *"${token,,}"* ]]; then

                    matches+=("$code|$name")
                fi

            done <<< "$countries_data"

            # ------------------------------------------------------------------
            # Nothing found.
            # ------------------------------------------------------------------

            if [[ "${#matches[@]}" -eq 0 ]]; then
                printf "\n  ⚠  Nothing found for: %s\n" "$token"
                printf "  Enter another search, or leave blank to skip.\n\n"
                failed=1
                break
            fi

            # ------------------------------------------------------------------
            # Exactly one match.
            # ------------------------------------------------------------------

            if [[ "${#matches[@]}" -eq 1 ]]; then
                resolved+=("${matches[0]%%|*}")
                continue
            fi

            # ------------------------------------------------------------------
            # Multiple matches.
            # ------------------------------------------------------------------

            printf "\n"

            for i in "${!matches[@]}"; do
                printf "   [%d] %-4s %s\n" \
                    "$((i + 1))" \
                    "${matches[$i]%%|*}" \
                    "${matches[$i]#*|}"
            done

            printf "\n"

            selected=""

            while true; do

                read -rp \
                    "  Select [1-${#matches[@]}], or blank to search again: " \
                    choice

                [[ "$choice" == "z" ]] && return

                if [[ -z "$choice" ]]; then
                    failed=1
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

            if [[ -z "$selected" ]]; then
                break
            fi

            resolved+=("${selected%%|*}")
        done

        (( failed )) && continue

        # ----------------------------------------------------------------------
        # Remove duplicate country codes while preserving order.
        # ----------------------------------------------------------------------

        mapfile -t resolved < <(
            printf '%s\n' "${resolved[@]}" |
                awk 'NF && !seen[$0]++'
        )

        if [[ "${#resolved[@]}" -eq 0 ]]; then
            printf "\n  ⚠  No mirror countries selected.\n\n"
            continue
        fi

        # ----------------------------------------------------------------------
        # Build comma-separated final value.
        # ----------------------------------------------------------------------

        input=$(IFS=,; printf '%s' "${resolved[*]}")

        break
    done

    # --------------------------------------------------------------------------
    # Final validation against the SAME live Arch data.
    # --------------------------------------------------------------------------

    IFS=',' read -ra tokens <<< "$input"

    for token in "${tokens[@]}"; do

        if ! grep -Fq "${token}|" <<< "$countries_data"; then
            printf "\n  ⚠  Country is no longer present in Arch mirror data: %s\n\n" \
                "$token"
            return 1
        fi

    done

    # --------------------------------------------------------------------------
    # Commit.
    # --------------------------------------------------------------------------

    AG_P_MIRROR_COUNTRIES="$input"

    log_silent \
        "SETTER: mirrors — AG_P_MIRROR_COUNTRIES=$AG_P_MIRROR_COUNTRIES"
}