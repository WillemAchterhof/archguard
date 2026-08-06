#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Installer Modules
# ==============================================================================
#  ag_install/ag_orchestrator/modules.sh
#
#  Defines each installer stage as a module entry point.
#
#  Responsibilities:
#    - Wrap each stage's run_module + entry-function call
#
#  Does NOT:
#    - Decide pipeline order
#    - Handle user input, rendering, or validation itself
# ==============================================================================

module_precheck()
{
    run_module "$AG_DIR_CORE/precheck"
    run_precheck
}

module_prepare()
{
    run_module "$AG_DIR_CORE/prepare"
    run_prepare
}

module_menu()
{
    run_module "$AG_DIR_CORE/menu"
    run_menu
}

module_validate()
{
    run_module "$AG_DIR_CORE/validate"
    run_validation
}

module_install()
{
    run_module "$AG_DIR_CORE/install"
    run_install
}
