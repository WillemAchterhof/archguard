#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — EFI Info
# ==============================================================================
#  lib/prepare/storage/efi/info.sh
#
#  Requires:
#    - show_info (from lib/utilities/show_info.sh)
# ==============================================================================

show_efi_info()
{
    show_info "\
================================================
 EFI Partition
================================================
Stores the bootloader and kernel images UEFI
firmware loads directly.

  300M   Enough for a single kernel and fallback
         entry — tightest fit.
  500M   Comfortable headroom for multiple kernel
         versions or fallback boot entries.
  1G     Plenty of room, useful if you expect to
         keep several old kernels around."
}