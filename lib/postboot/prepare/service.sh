#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Service Preparation
# ==============================================================================
#  lib/postboot/prepare/service.sh
#
#  Prepares the systemd service that starts the ArchGuard post-install
#  process when AG_P_USERNAME logs in.
# ==============================================================================

prepare_service()
{
    local service_name="archguard-postinstall.service"
    local service_path="$AG_INSTALL_ROOT/etc/systemd/system/$service_name"
    local bash_profile="$AG_INSTALL_ROOT/home/$AG_P_USERNAME/.bash_profile"

    msg "Preparing postboot service"

    [[ -n "${AG_P_USERNAME:-}" ]] \
        || fatal "AG_P_USERNAME is not set"

    [[ -d "$AG_INSTALL_ROOT/home/$AG_P_USERNAME" ]] \
        || fatal "Home directory not found for user: $AG_P_USERNAME"

    [[ -f "$bash_profile" ]] \
        || touch "$bash_profile"

    # --------------------------------------------------------------------------
    # Create root systemd service
    # --------------------------------------------------------------------------

    mkdir -p -- "$(dirname "$service_path")"

    cat > "$service_path" <<'EOF'
[Unit]
Description=ArchGuard Post-Install Configuration

[Service]
Type=oneshot
ExecStart=/opt/archguard/run.sh
User=root
Group=root
RemainAfterExit=no
EOF

    chmod 644 "$service_path"

    # --------------------------------------------------------------------------
    # Start the service when the installation user logs in
    # --------------------------------------------------------------------------

    cat >> "$bash_profile" <<'EOF'

# ARCHGUARD_POSTBOOT_START
if ! systemctl is-active --quiet archguard-postinstall.service; then
    systemctl start archguard-postinstall.service
fi
# ARCHGUARD_POSTBOOT_END
EOF

    # --------------------------------------------------------------------------
    # Set ownership inside the installed system
    # --------------------------------------------------------------------------

    run_chroot chown "$AG_P_USERNAME:$AG_P_USERNAME" \
        "/home/$AG_P_USERNAME/.bash_profile"

    # --------------------------------------------------------------------------
    # Reload systemd configuration inside the installed system
    # --------------------------------------------------------------------------

    run_chroot systemctl daemon-reload

    msg "Postboot service prepared for user: $AG_P_USERNAME"
}