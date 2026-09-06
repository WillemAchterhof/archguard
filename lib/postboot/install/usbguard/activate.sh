#!/usr/bin/env bash

# ==============================================================================
# ArchGuard — USBGuard
# ==============================================================================

usbguard_install() {
    printf "[*] Installing USBGuard..."
    pacman -Syu --noconfirm usbguard
}

usbguard_policy() {
    printf "[*] Generating USBGuard policy..."
    usbguard generate-policy > /etc/usbguard/rules.conf
}

usbguard_turn_on() {
    printf "[*] Enabling USBGuard..."
    systemctl enable usbguard

    printf "[*] Starting USBGuard..."
    systemctl start usbguard
}

activate_usbguard() {
    usbguard_install
    usbguard_policy
    usbguard_turn_on
}