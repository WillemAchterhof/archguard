#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Environment configuration
# ==============================================================================
#  lib/install/system/environment.sh
# ==============================================================================

configure_environment()
{
    msg "Configuring system environment"

    cat > "$AG_INSTALL_ROOT/etc/environment" <<'EOF'
EDITOR=nvim
VISUAL=nvim
EOF

    chmod 644 "$AG_INSTALL_ROOT/etc/environment"

    msg "System environment configured"
}