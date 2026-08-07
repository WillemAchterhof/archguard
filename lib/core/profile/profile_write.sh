#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Writing
# ==============================================================================
#  lib/core/profile/profile_write.sh
#
#  Serializes AG_P_* variables to a profile's system.env file.
#
#  Requires:
#    - A target file path from the caller (profile_save / profile_save_as)
#
#  Does NOT:
#    - Decide which profile or path to write to
#    - Create directories
#    - Prompt the user
# ==============================================================================

profile_write_file()
{
    local file="$1"
    local var

    : > "$file"

    while IFS= read -r var; do
        [[ -n "$var" ]] || continue
        printf "%s=%q\n" "$var" "${!var}" >> "$file"
    done < <(compgen -A variable AG_P_ || true)

    chmod 600 "$file"
}
