#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Optional Field Validation
# ==============================================================================
#  lib/validate/validate_optional.sh
#
#  Checks fields where empty is a legitimate, deliberate value — not
#  "not yet set" (see validate_required.sh for fields where it is).
#  A blank value here is not automatically a failure. What IS checked
#  is internal consistency between a field pair: both halves must
#  agree — either both empty (deliberately off) or both set (on,
#  with a computed value). One set and the other blank can only
#  happen from a hand-edited profile, and is what gets flagged.
#
#  Currently covers:
#    - AG_P_SWAP_ENABLED / AG_P_SWAP_SIZE
#
#  Requires:
#    - fail_check (lib/core/logging/checks.sh)
#
#  Sets:
#    - AG_V_SWAP ("0" valid, "1" invalid)
#
#  Does NOT:
#    - Touch any AG_P_* value
#    - Treat "empty" as automatically invalid
#
#  Returns:
#    - 0 if every pair is consistent
#    - 1 if one or more are mismatched
# ==============================================================================

validate_optional_fields()
{
    local -a enabled_fields=(AG_P_SWAP_ENABLED)
    local -a size_fields=(AG_P_SWAP_SIZE)
    local -a flags=(AG_V_SWAP)
    local -a labels=("Swap is inconsistent (enabled/size mismatch)")

    local i enabled_var size_var enabled size flag failed=0

    for i in "${!enabled_fields[@]}"; do
        enabled_var="${enabled_fields[$i]}"
        size_var="${size_fields[$i]}"
        flag="${flags[$i]}"

        enabled="${!enabled_var:-}"
        size="${!size_var:-}"

        if [[ -z "$enabled" && -z "$size" ]] || [[ -n "$enabled" && -n "$size" ]]; then
            printf -v "$flag" "0"
        else
            printf -v "$flag" "1"
            fail_check "${labels[$i]}"
            failed=1
        fi
    done

    return "$failed"
}
