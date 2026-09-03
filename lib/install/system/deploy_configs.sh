#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Deploy Config Files
# ==============================================================================
#  lib/install/system/deploy_configs.sh
#
#  Copies static config files from $AG_DIR_CONFIGS_SYSTEM into the target system.
#  Deploy only — does not enable services or otherwise configure anything.
#
#  Requires:
#    - AG_INSTALL_ROOT
#    - AG_DIR_CONFIGS_SYSTEM
#    - AG_HW_WAN_IFACE (nftables.conf template substitution)
# ==============================================================================

verify_configs_folders()
{
    msg "Verifying config destination folders"

    mkdir -p "$AG_INSTALL_ROOT/etc/NetworkManager/conf.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/sysctl.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/modprobe.d"
}

deploy_configs()
{
    msg "Deploying system config files"

    # --------------------------------------------------------------------------
    # NetworkManager
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/NetworkManager.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/NetworkManager.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/NetworkManager.conf" \
        "$AG_INSTALL_ROOT/etc/NetworkManager/NetworkManager.conf"

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/20-mac-randomize.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/20-mac-randomize.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/20-mac-randomize.conf" \
        "$AG_INSTALL_ROOT/etc/NetworkManager/conf.d/20-mac-randomize.conf"

    # --------------------------------------------------------------------------
    # Firewall (nftables)
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/nftables.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/nftables.conf"
    [[ "$AG_HW_WAN_IFACE" != "unknown" ]] \
        || fatal "Could not detect WAN interface — refusing to deploy nftables.conf"

    sed "s/__AG_WAN_IFACE__/$AG_HW_WAN_IFACE/g" \
        "$AG_DIR_CONFIGS_SYSTEM/nftables.conf" \
        > "$AG_INSTALL_ROOT/etc/nftables.conf"

    # --------------------------------------------------------------------------
    # Sysctl hardening
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/99-hardening.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/99-hardening.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/99-hardening.conf" \
        "$AG_INSTALL_ROOT/etc/sysctl.d/99-hardening.conf"

    # --------------------------------------------------------------------------
    # Kernel module blacklist
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/blacklist.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/blacklist.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/blacklist.conf" \
        "$AG_INSTALL_ROOT/etc/modprobe.d/blacklist.conf"

    msg "Config files deployed"
}