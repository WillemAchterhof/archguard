#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Module Runner
# ==============================================================================
# install/orchestrator/run_module.sh
#
#  Loads and logs a single installer module.
#
#  Responsibilities:
#    - Source a module file
#    - Track and log the current module
#
#  Does NOT:
#    - Decide which modules run, or in what order
#    - Execute module logic itself
# ==============================================================================

run_module()
{
    local module_dir="$1"
    local name
    name="$(basename "$module_dir")"

    [[ -d "$module_dir" ]] \
        || fatal "Module missing: $module_dir"

    local entry="$module_dir/module.sh"
    [[ -f "$entry" ]] \
        || fatal "Module entry missing: $entry"

    log_header "MODULE START: $name"
    AG_CURRENT_MODULE="$name"
    export AG_CURRENT_MODULE
    source "$entry"
    log_header "MODULE LOADED: $name"
}
