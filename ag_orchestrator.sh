#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================================
#  Arch Secure Installer V2.6 — Main Orchestrator
# ==============================================================================
#  ag_install/ag_orchestrator.sh
#
#  Pure orchestration layer.
#
#  Responsibilities:
#    - Initialize installer environment
#    - Load shared services
#    - Load and execute installer modules
#
#  Does NOT:
#    - Handle user input
#    - Render menus
#    - Validate profiles
#    - Install packages
#    - Modify disks
# ==============================================================================

# ------------------------------------------------------------------------------
# Step 0: Determine installer root
# ------------------------------------------------------------------------------

readonly AG_DIR_MAIN="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ------------------------------------------------------------------------------
# Step 1: Initialize Core Services
# ------------------------------------------------------------------------------

init_core()
{
    source "$AG_DIR_MAIN/ag_install/lib/core/variables/module.sh" \
        || { printf "[FATAL] Failed loading variables.\n"; exit 1; }

    source "$AG_DIR_LOGGING/module.sh" \
        || { printf "[FATAL] Failed loading logging.\n"; exit 1; }
    init_logging
}

load_pipeline(){
    for file in "$AG_DIR_PIPELINE"/*.sh; do
        [[ -f "$file" ]] || continue
        source "$file"
    done
}

main(){
    init_core

    trap 'trap_err' ERR

    load_pipeline
    run_pipeline "$@"
}

main "$@"
