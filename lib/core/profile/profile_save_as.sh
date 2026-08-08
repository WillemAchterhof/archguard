#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Save As
# ==============================================================================
#  lib/core/profile/profile_save_as.sh
#
#  Prompts for a profile name, then delegates to profile_save.
#
#  Requires:
#    - validate_name (from lib/utilities/validate_name.sh)
#    - profile_save (from lib/core/profile/profile_save.sh)
#
#  Does NOT:
#    - Load profiles
#    - Write files itself (see profile_save)
# ==============================================================================

profile_save_as()
{
    local raw
    local name

    printf "\n Profile name: "
    read -r raw

    validate_name "$raw" || { sleep 1; return 1; }
    name="$AG_VALIDATED_NAME"

    AG_PROFILE_NAME="$name"

    profile_save
}