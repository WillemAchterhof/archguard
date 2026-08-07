#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Hardware Display Formatting
# ==============================================================================
#  lib/menu/format_hardware.sh
#
#  Translates raw AG_HW_* detection values into display strings.
#
#  Requires:
#    - AG_HW_SB_STATE, AG_HW_TPM_PRESENT (from precheck)
#
#  Populates:
#    - AG_DISPLAY_SB
#    - AG_DISPLAY_TPM
#
#  Does NOT:
#    - Detect hardware
#    - Modify AG_HW_* values
#    - Render menus
# ==============================================================================

format_hardware()
{
    case "$AG_HW_SB_STATE" in
        enabled)      AG_DISPLAY_SB="Available (locked)" ;;
        "setup mode") AG_DISPLAY_SB="Available (setup mode)" ;;
        disabled)     AG_DISPLAY_SB="Available (disabled)" ;;
        unavailable)  AG_DISPLAY_SB="Not available" ;;
        *)            AG_DISPLAY_SB="Undetected" ;;
    esac

    case "$AG_HW_TPM_PRESENT" in
        yes) AG_DISPLAY_TPM="Available" ;;
        *)   AG_DISPLAY_TPM="Not available" ;;
    esac
}
