#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Main Pipeline
# ==============================================================================
#  ag_install/orchestrator/pipeline.sh
#
#  Defines the installer's top-level stage sequence.
#
#  Responsibilities:
#    - Run each stage in order
#    - Handle early exit
#
#  Does NOT:
#    - Implement stage logic itself
#    - Load modules directly (uses run_module via modules.sh)
# ==============================================================================

run_pipeline()
{
    log_header "Arch Secure Installer V2.6"
    msg "Installer started"

    msg "Loading core services"
    module_services

    msg "Hardware detection"
    module_precheck

    msg "Prepare installer"
    module_prepare

    msg "Configure profile"
    module_menu

#    msg "Validate profile"
#    module_validate

#    msg "Install system"
#    module_install

    msg "Installer finished"
    log_header "SESSION COMPLETE"
}
