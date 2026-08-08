#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Saving
# ==============================================================================
#  lib/core/profile/profile_save.sh
#
#  Saves the currently active AG_P_* configuration to disk.
#
#  Requires:
#    - AG_DIR_PROFILE_STATE (from lib/core/variables/paths.sh)
#    - profile_write_file (from lib/core/profile/profile_write.sh)
#
#  Behavior:
#    - Saves to the profile named by AG_PROFILE_NAME, or "Default"
#      if nothing is currently active.
#    - Overwrites the target profile's system.env if it already exists.
#
#  Does NOT:
#    - Prompt for a profile name (see profile_save_as)
#    - Load profiles
#    - Save package lists or pacstrap files
# ==============================================================================

profile_save()
{
    local name="${AG_PROFILE_NAME:-Default}"
    local dir="$AG_DIR_PROFILE_STATE/$name"
    local file="$dir/system.env"

    mkdir -p "$dir" \
        || { printf " Failed to create profile directory: %s\n" "$dir"; return 1; }

    profile_write_file "$file"

    write_btrfs_scratch
    save_btrfs_profile "$dir/btrfs_config.env"

    AG_PROFILE_NAME="$name"

    msg "Profile saved: $file"
}
