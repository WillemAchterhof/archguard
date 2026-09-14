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

usbguard_ipc() {
    local acl_dir="/etc/usbguard/IPCAccessControl.d"
    local target_user="$AG_P_USERNAME"

    [[ -n "${AG_P_USERNAME:-}" ]] \
        || fatal "AG_P_USERNAME is not set"

    printf "[*] Configuring USBGuard IPC access for %s..." "$target_user"

    mkdir -p "$acl_dir"

    cat > "$acl_dir/$target_user" <<EOF
Devices=list
Devices=modify
EOF

    chmod 600 "$acl_dir/$target_user"
    chown root:root "$acl_dir/$target_user"
}

usbguard_turn_on() {
    printf "[*] Enabling USBGuard..."
    systemctl enable usbguard

    printf "[*] Starting USBGuard..."
    systemctl start usbguard
}

base_usbguard() {
    usbguard_install
    usbguard_policy
    usbguard_ipc
    usbguard_turn_on
}
