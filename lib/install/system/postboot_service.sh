#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Service
# ==============================================================================
#  lib/install/system/postboot_service.sh
# ==============================================================================

configure_postboot_service()
{
    local service_file="$AG_INSTALL_ROOT/etc/systemd/system/archguard-postboot.service"

    msg "Installing ArchGuard post-boot service"

    cat > "$service_file" <<'EOF'
[Unit]
Description=ArchGuard Post-Boot Configuration
After=network-online.target
Wants=network-online.target
ConditionPathExists=/mnt/postboot

[Service]
Type=oneshot
ExecStart=/bin/bash /mnt/postboot/run.sh
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "$service_file"

    run_chroot systemctl enable archguard-postboot.service

    msg "ArchGuard post-boot service enabled"
}