#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Services Entry Point
# ==============================================================================
#  lib/core/services/run.sh
#
#  Loads and initializes core services required before the pipeline runs.
#
#  Requires:
#    - AG_DIR_UTILITIES, AG_DIR_PROFILE_LIB (from lib/core/variables/paths.sh)
#
#  Does NOT:
#    - Load its own dependencies via module.sh (utilities/profile are
#      separate module directories, loaded explicitly here)
# ==============================================================================

run_services()
{
    source "$AG_DIR_UTILITIES/module.sh" \
        || fatal "Failed loading utilities."

    source "$AG_DIR_PROFILE_LIB/module.sh" \
        || fatal "Failed loading profile handling."
    load_default_profile

    msg "Core services loaded"
}
