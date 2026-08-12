#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Installer Modules
# ==============================================================================
#  install/orchestrator/modules.sh
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

module_services()
{
    run_module "$AG_DIR_SERVICES"
    run_services
}

module_precheck()
{
    run_module "$AG_DIR_PRECHECK"
    run_precheck
}

module_prepare()
{
    run_module "$AG_DIR_PREPARE"
    run_disk
}

module_menu()
{
    run_module "$AG_DIR_MENU"
    run_menu
}

module_validate()
{
    run_module "$AG_DIR_VALIDATE"
    run_validation
}

module_install()
{
    run_module "$AG_DIR_INSTALLER"
    run_install
}
