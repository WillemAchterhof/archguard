#!/usr/bin/env bash

# ==============================================================================
# ArchGuard — USBGuard
# ==============================================================================

usbguard_install() {
    log "[*] Installing USBGuard..."
    pacman -Syu --noconfirm usbguard
}

usbguard_policy() {
    log "[*] Generating USBGuard policy..."
    usbguard generate-policy > /etc/usbguard/rules.conf
}

usbguard_turn_on() {
    log "[*] Enabling USBGuard..."
    systemctl enable usbguard

    log "[*] Starting USBGuard..."
    systemctl start usbguard
}

activate_usbguard() {
    usbguard_install
    usbguard_policy
    usbguard_turn_on
}