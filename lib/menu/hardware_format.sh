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
        enabled)      AG_DISPLAY_SB="Locked" ;;
        "setup mode") AG_DISPLAY_SB="Unlocked" ;;
        disabled)     AG_DISPLAY_SB="Disabled" ;;
        unavailable)  AG_DISPLAY_SB="-" ;;
        *)            AG_DISPLAY_SB="Undetected" ;;
    esac

   case "$AG_HW_TPM_PRESENT" in
    yes)
        case "$AG_HW_TPM_VERSION" in
            unknown) AG_DISPLAY_TPM="undetected" ;;
            *)       AG_DISPLAY_TPM="$AG_HW_TPM_VERSION" ;;
        esac
        ;;
    *)
        AG_DISPLAY_TPM="-"
        ;;
esac
}
