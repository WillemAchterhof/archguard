#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Module
# ==============================================================================
#  lib/profile/module.sh
#
#  Loads profile handling components.
#
#  Responsibilities:
#    - Load profile load/save functions
#
#  Does NOT:
#    - Load profile files itself
#    - Source itself
# ==============================================================================

for file in "$AG_DIR_PROFILE_LIB"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done
