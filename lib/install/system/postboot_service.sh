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
ConditionPathExists=/opt/archguard/postboot/run.sh

[Service]
Type=oneshot
ExecStart=/bin/bash /opt/archguard/postboot/run.sh
StandardOutput=journal+console
StandardError=journal+console
RemainAfterExit=no
EOF

    chmod 644 "$service_file"

    # --------------------------------------------------------------------------
    # Create the user-session trigger.
    #
    # This service starts when the user's systemd session starts after login.
    # It triggers the privileged ArchGuard system service.
    # --------------------------------------------------------------------------

    local user_service_dir="$AG_INSTALL_ROOT/etc/systemd/user"
    local user_service_file="$user_service_dir/archguard-postboot-trigger.service"

    mkdir -p "$user_service_dir"

    cat > "$user_service_file" <<'EOF'
[Unit]
Description=ArchGuard Post-Boot Login Trigger
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl start archguard-postboot.service
RemainAfterExit=yes
EOF

    chmod 644 "$user_service_file"

    # --------------------------------------------------------------------------
    # Enable the trigger globally for user sessions.
    # --------------------------------------------------------------------------

    mkdir -p "$AG_INSTALL_ROOT/etc/systemd/user/default.target.wants"

    ln -sf \
        "../archguard-postboot-trigger.service" \
        "$AG_INSTALL_ROOT/etc/systemd/user/default.target.wants/archguard-postboot-trigger.service"

    # Reload systemd configuration.
    run_chroot systemctl daemon-reload

    msg "ArchGuard post-boot service installed"
    msg "ArchGuard post-boot will run after user login"
}