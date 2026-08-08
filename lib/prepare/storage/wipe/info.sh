#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Wipe Info
# ==============================================================================
#  lib/prepare/storage/wipe/info.sh
#
#  Requires:
#    - show_info (from lib/utilities/show_info.sh)
# ==============================================================================

show_wipe_info()
{
    show_info "\
================================================
 Disk Wipe Mode
================================================
  quick      Clears partition table and LUKS
             headers only. Safe if the disk's
             previous install was already
             encrypted — old data is
             unrecoverable ciphertext.

  secure     Single-pass overwrite of the full
             disk with random data before
             partitioning. Slower, recommended
             if the disk previously held
             unencrypted data.

  paranoia   Multi-pass overwrite of the full
             disk. Significantly slower — use
             only if you have a specific reason
             to distrust a single-pass wipe."
}