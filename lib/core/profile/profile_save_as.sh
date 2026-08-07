#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Save As
# ==============================================================================
#  lib/core/profile/profile_save_as.sh
#
#  Prompts for a profile name and saves the current AG_P_* configuration
#  under it, making it the active profile.
#
#  Requires:
#    - AG_DIR_PROFILE_STATE (from lib/core/variables/paths.sh)
#    - validate_name (from lib/utilities/validate_name.sh)
#    - profile_write_file (from lib/core/profile/profile_write.sh)
#
#  Does NOT:
#    - Load profiles
#    - Save package lists or pacstrap files
# ==============================================================================

profile_save_as()
{
    local raw
    local name
    local dir
    local file

    printf "\n Profile name: "
    read -r raw

    validate_name "$raw" || { sleep 1; return 1; }
    name="$AG_VALIDATED_NAME"

    dir="$AG_DIR_PROFILE_STATE/$name"
    file="$dir/system.env"

    mkdir -p "$dir" \
        || { printf " Failed to create profile directory: %s\n" "$dir"; return 1; }

    profile_write_file "$file"

    AG_PROFILE_NAME="$name"

    msg "Profile saved: $file"
}
