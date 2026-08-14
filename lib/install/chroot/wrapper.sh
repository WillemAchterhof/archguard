#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Chroot Helper
# ==============================================================================
#  lib/install/chroot/wrapper.sh
#
#  Provides a single entry point for executing commands inside the
#  target system.
#
#  Requires:
#    - /mnt mounted and containing a valid Arch installation
#
#  Does NOT:
#    - Configure the system
#    - Modify installer state
# ==============================================================================

run_chroot()
{
    arch-chroot /mnt "$@"
}
