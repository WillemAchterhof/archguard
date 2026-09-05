#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Service
# ==============================================================================
#  lib/install/system/postboot_service.sh
# ===============================================================================

configure_postboot_service()
{
    local service_file="$AG_INSTALL_ROOT/etc/systemd/system/archguard-postboot.service"

    msg "Installing ArchGuard post-boot service"

    cat > "$service_file" <<'EOF_SERVICE'
[Unit]
Description=ArchGuard Post-Boot Configuration
ConditionPathExists=/opt/archguard/postboot/run.sh

[Service]
Type=oneshot
ExecStart=/bin/bash /opt/archguard/postboot/run.sh
StandardOutput=journal+console
StandardError=journal+console
RemainAfterExit=no
EOF_SERVICE

    chmod 644 "$service_file"

    run_chroot systemctl daemon-reload

    msg "ArchGuard post-boot service installed"
}