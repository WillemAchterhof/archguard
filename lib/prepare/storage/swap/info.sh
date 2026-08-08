#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Info
# ==============================================================================
#  lib/prepare/storage/swap/info.sh
#
#  Requires:
#    - show_info (from lib/utilities/show_info.sh)
# ==============================================================================

show_swap_info()
{
    show_info "\
================================================
 Swap
================================================
Swap always lives as an LVM logical volume
inside the LUKS-encrypted container — no swap
file, no separate raw partition.

  Full    Size equals total RAM. Supports
          hibernation (suspend-to-disk).

  Half    Size is half of total RAM. No
          hibernation support.

  None    No swap volume created."
}