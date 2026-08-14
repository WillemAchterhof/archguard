#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — CPU Package Selection
# ==============================================================================
#
#  Maps already-detected hardware vendors (from precheck) to the
#  pacstrap package names needed for microcode support.
#  Each function only echoes package names — neither one detects
#  hardware itself, and neither installs anything.
#
#  Requires:
#    - AG_HW_CPU_VENDOR (from lib/core/precheck/cpu.sh)
#
#  Does NOT:
#    - Detect hardware (see lib/core/precheck/)
#    - Touch /mnt or install anything (see install_base in base.sh)
# ==============================================================================

get_cpu_pkg()
{
    case "${AG_HW_CPU_VENDOR:-unknown}" in
        intel)
            echo "intel-ucode"
            ;;
        amd)
            echo "amd-ucode"
            ;;
        *)
            log "[!] Unknown CPU vendor: ${AG_HW_CPU_VENDOR:-unknown}"
            echo ""
            ;;
    esac
}
