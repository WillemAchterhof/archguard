#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Preparation
# ==============================================================================
#  lib/install/system/postboot.sh
# ==============================================================================

prepare_luks_key()
{
    local key_dir="$AG_INSTALL_ROOT/opt/archguard"
    local key_file="$key_dir/luks.key"

    msg "Preparing temporary LUKS key for first boot"

    install -d -m 700 "$key_dir"

    printf '%s\n' "$AGS_LUKS_PASSPHRASE" > "$key_file"
    chmod 600 "$key_file"

    msg "Temporary LUKS key prepared"
}

configure_postboot()
{
    local postboot_src="$AG_DIR_POSTBOOT"
    local postboot_dst="$AG_INSTALL_ROOT/opt/archguard/postboot"

    msg "Preparing post-boot configuration"

    [[ -d "$postboot_src" ]] \
        || fatal "Postboot directory missing: $postboot_src"

    rm -rf -- "$postboot_dst"

    mkdir -p "$postboot_dst"

    cp -a -- "$postboot_src/." "$postboot_dst/"

    chmod 700 "$postboot_dst"
    find "$postboot_dst" -type f -name '*.sh' -exec chmod 700 {} \;

    prepare_luks_key

    msg "Post-boot configuration prepared"
}