#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Service Preparation
# ==============================================================================
#  lib/postboot/prepare/service.sh
#
#  Prepares the systemd service that starts the ArchGuard post-install
#  process after AG_P_USERNAME logs in.
# ==============================================================================

prepare_service()
{
    local service_name="archguard-postinstall.service"
    local service_path="$AG_INSTALL_ROOT/etc/systemd/system/$service_name"

    msg "Preparing postboot service"

    [[ -n "${AG_P_USERNAME:-}" ]] \
        || fatal "AG_P_USERNAME is not set"

    [[ -d "$AG_INSTALL_ROOT/home/$AG_P_USERNAME" ]] \
        || fatal "Home directory not found for user: $AG_P_USERNAME"

    # --------------------------------------------------------------------------
    # Create root systemd service
    # --------------------------------------------------------------------------

    mkdir -p -- "$(dirname "$service_path")"

    cat > "$service_path" <<EOF
[Unit]
Description=ArchGuard Post-Install Configuration
After=systemd-logind.service
Wants=systemd-logind.service

[Service]
Type=oneshot
User=root
Group=root

ExecStart=/bin/bash -c 'while ! loginctl list-sessions --no-legend 2>/dev/null | awk "{print \\\$3}" | grep -Fxq "$AG_P_USERNAME"; do sleep 1; done; exec /opt/archguard/run.sh'

RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "$service_path"

    # --------------------------------------------------------------------------
    # Remove the old shell-based postboot trigger if it exists
    # --------------------------------------------------------------------------

    local bash_profile="$AG_INSTALL_ROOT/home/$AG_P_USERNAME/.bash_profile"

    if [[ -f "$bash_profile" ]]; then
        sed -i '/# ARCHGUARD_POSTBOOT_START/,/# ARCHGUARD_POSTBOOT_END/d' \
            "$bash_profile"
    fi

    # --------------------------------------------------------------------------
    # Reload and enable service in installed system
    # --------------------------------------------------------------------------

    run_chroot systemctl daemon-reload
    run_chroot systemctl enable "$service_name"

    msg "Postboot service prepared for user: $AG_P_USERNAME"
}