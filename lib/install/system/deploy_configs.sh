#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Deploy Config Files
# ==============================================================================
#  lib/install/system/deploy_configs.sh
#
#  Copies static config files from $AG_DIR_SYSCON into the target system.
#  Deploy only — does not enable services or otherwise configure anything.
#
#  Requires:
#    - AG_INSTALL_ROOT
#    - AG_DIR_SYSCON
# ==============================================================================

verify_configs_folders()
{
    msg "Verifying config destination folders"

    mkdir -p "$AG_INSTALL_ROOT/etc/NetworkManager/conf.d"
}

deploy_configs()
{
    msg "Deploying system config files"

    # --------------------------------------------------------------------------
    # NetworkManager
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_SYSCON/NetworkManager.conf" ]] \
        || fatal "Missing config: $AG_DIR_SYSCON/NetworkManager.conf"
    cp "$AG_DIR_SYSCON/NetworkManager.conf" \
        "$AG_INSTALL_ROOT/etc/NetworkManager/NetworkManager.conf"

    [[ -f "$AG_DIR_SYSCON/20-mac-randomize.conf" ]] \
        || fatal "Missing config: $AG_DIR_SYSCON/20-mac-randomize.conf"
    cp "$AG_DIR_SYSCON/20-mac-randomize.conf" \
        "$AG_INSTALL_ROOT/etc/NetworkManager/conf.d/20-mac-randomize.conf"

    msg "Config files deployed"
}