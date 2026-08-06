#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Variable Initializer
# ==============================================================================
#  lib/core/variables/module.sh
#
#  Loads all installer variable definitions.
#
#  Responsibilities:
#    - Load path variables
#    - Load hardware variables
#    - Load profile variables
#    - Load runtime variables
#
#  Does NOT:
#    - Detect hardware
#    - Modify variables
#    - Validate configuration
#
# Variable namespaces:
#
# AG_     Installer-wide variables
# AG_P_   Profile configuration
# AG_HW_  Hardware detection results
#
# AGS_    Sensitive runtime-only values
#         variables must never be stored globally.
# ==============================================================================

set -Eeuo pipefail

: "${AG_DIR_MAIN:?AG_DIR_MAIN not set — source from ag_orchestrator.sh only}"

AG_DIR_VARS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly AG_DIR_VARS

set -a

for file in "$AG_DIR_VARS"/*.sh; do
    [[ -f "$file" ]] || continue
    source "$file"
done

set +a
