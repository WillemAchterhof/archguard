#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Info
# ==============================================================================
#  lib/prepare/security/luks/info.sh
#
#  Requires:
#    - show_info (from lib/utilities/show_info.sh)
# ==============================================================================

show_luks_info()
{
    show_info "\
================================================
 LVM on LUKS
================================================
Disk encryption is mandatory on this installer.
Everything (root, home, swap) lives inside one
LUKS-encrypted container, with LVM managing the
volumes inside it.

  Auto      A random passphrase is generated for
            you at install time and shown once —
            write it down before continuing.
  Manual    You are asked to type and confirm your
            own passphrase at install time.

The passphrase itself is never generated or shown
here — only the method is chosen now."
}