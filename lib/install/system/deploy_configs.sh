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
    readonly AG_POST_CONF="$AG_INSTALL_ROOT/opt/archguard/state/config"
    
    msg "Verifying config destination folders"

    mkdir -p "$AG_INSTALL_ROOT/etc/NetworkManager/conf.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/sysctl.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/modprobe.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/systemd/resolved.conf.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/systemd/journald.conf.d"
    mkdir -p "$AG_INSTALL_ROOT/etc/profile.d"
    mkdir -p "$AG_INSTALL_ROOT/opt/archguard/state/config"
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

    # --------------------------------------------------------------------------
    # DNS (Mullvad DoT via systemd-resolved)
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/resolved-mullvad.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/resolved-mullvad.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/resolved-mullvad.conf" \
        "$AG_INSTALL_ROOT/etc/systemd/resolved.conf.d/mullvad.conf"

    # --------------------------------------------------------------------------
    # Journald
    # --------------------------------------------------------------------------

    [[ -f "$AG_DIR_CONFIGS_SYSTEM/journald-persistent.conf" ]] \
        || fatal "Missing config: $AG_DIR_CONFIGS_SYSTEM/journald-persistent.conf"
    cp "$AG_DIR_CONFIGS_SYSTEM/journald-persistent.conf" \
        "$AG_INSTALL_ROOT/etc/systemd/journald.conf.d/00-persistent.conf"

    msg "Config files deployed"

    # --------------------------------------------------------------------------
    # Temporary Wi-Fi credentials for postboot
    # --------------------------------------------------------------------------

    if [[ -f "$AG_DIR_CONFIG/wifi.env" ]]; then
        msg "Deploying temporary Wi-Fi configuration"

        mkdir -p "$AG_POST_CONF"

        cp "$AG_DIR_CONFIG/wifi.env" \
            "$AG_POST_CONF/wifi.env"

        chmod 600 \
            "$AG_POST_CONF/wifi.env"
    else
        msg "No Wi-Fi configuration found — skipping"
    fi
}