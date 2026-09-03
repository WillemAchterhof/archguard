#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System configuration
# ==============================================================================
#  lib/install/system/run.sh
# ==============================================================================

configure_system()
{
    configure_pacman
    chroot_pacman_mirrors
    update_system

    configure_timezone
    configure_locale
    configure_keyboard
    configure_hostname
    configure_user
    
    verify_configs_folders
    deploy_configs
    #configure_services
    
    msg "System Configured"
}