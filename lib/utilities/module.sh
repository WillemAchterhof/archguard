#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Utilities Module
# ==============================================================================
#  lib/utilities/module.sh
#
#  Loads general-purpose helper functions shared across the installer.
#
#  Does NOT:
#    - Contain installer-specific logic
#    - Source itself
# ==============================================================================

for file in "$AG_DIR_UTILITIES"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done
