#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Hostname configuration
# ==============================================================================
#  lib/install/system/hostname.sh
#
#  Requires:
#    - AG_P_HOSTNAME
# ==============================================================================

configure_hostname()
{
    msg "Configuring hostname: $AG_P_HOSTNAME"

    printf '%s\n' "$AG_P_HOSTNAME" \
        > "$AG_INSTALL_ROOT/etc/hostname"

    cat > "$AG_INSTALL_ROOT/etc/hosts" <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $AG_P_HOSTNAME.localdomain $AG_P_HOSTNAME
EOF

    msg "Hostname configured"
}