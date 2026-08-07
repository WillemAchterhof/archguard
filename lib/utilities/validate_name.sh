#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Name Validation
# ==============================================================================
#  lib/utilities/validate_name.sh
#
#  Validates and normalizes a user-supplied name (profile names, etc.).
#
#  Behavior:
#    - Trims leading/trailing whitespace.
#    - Rejects empty names.
#    - Rejects names containing anything other than letters, numbers,
#      - or _.
#    - Any casing/spacing of exactly "default" normalizes to "Default".
#      Names that merely contain "default" (e.g. Default_HP) are left
#      untouched.
#
#  Usage:
#    if validate_name "$raw_input"; then
#        name="$AG_VALIDATED_NAME"
#    fi
#
#  Populates:
#    - AG_VALIDATED_NAME (only on success)
#
#  Does NOT:
#    - Prompt the user
#    - Know anything about profiles, disks, or any other domain
# ==============================================================================

validate_name()
{
    local raw="$1"
    local name

    name="${raw#"${raw%%[![:space:]]*}"}"
    name="${name%"${name##*[![:space:]]}"}"

    if [[ -z "$name" ]]; then
        printf " Name cannot be empty.\n"
        return 1
    fi

    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        printf " Invalid name. Use letters, numbers, - or _ only.\n"
        return 1
    fi

    if [[ "${name,,}" == "default" ]]; then
        name="Default"
    fi

    AG_VALIDATED_NAME="$name"
}
