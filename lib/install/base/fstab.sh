#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Fstab Generation & Chroot Entry
# ==============================================================================
#  lib/install/base/fstab.sh
#
#  Requires:
#    - /mnt already mounted, including swap active if enabled
#      (see lib/install/disk/mount.sh)
#    - Base system installed (see install_base in base.sh)
#
#  genfstab reflects whatever is actually mounted right now — it does
#  not need to be told the filesystem type, and it picks up active
#  swap automatically. Any options that should appear in fstab
#  (noatime, compress=, fmask=/dmask=, etc.) have to already be set
#  at mount time in mount.sh; genfstab only mirrors reality, it
#  doesn't add anything of its own.
#
#  run_chroot is a thin wrapper around arch-chroot — every later
#  chroot-stage file (timezone, locale, hostname, users, mkinitcpio,
#  bootloader) should call it instead of invoking arch-chroot /mnt
#  directly, so the target mount point only needs to be named here.
# ==============================================================================

assert_target_root()
{
    [[ -d /mnt/etc ]] \
        || fatal "Target root not found: /mnt"
}

install_fstab()
{
    assert_target_root
    
    msg "Generating fstab"
    genfstab -U /mnt > /mnt/etc/fstab
    msg "fstab generated."
}

run_chroot()
{
    arch-chroot /mnt "$@"
}
