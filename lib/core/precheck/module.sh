#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================================
#  Arch Secure Installer V2.6 — Precheck Initializer
# ==============================================================================
#  lib/core/precheck/module.sh
#
#  Loads and executes all hardware detection modules.
#
#  Responsibilities:
#    - Load precheck modules
#    - Detect current hardware
#    - Populate AG_HW_* variables
#
#  Does NOT:
#    - Modify installer configuration
#    - Validate profiles
#    - Perform installation tasks
# ==============================================================================

for file in "$AG_DIR_PRECHECK"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done