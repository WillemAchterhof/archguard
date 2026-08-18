#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Secure Boot Certificate Setter
# ==============================================================================
#  lib/prepare/system/sb_certificate.sh
#
#  Pressing [n] cycles through the Secure Boot certificate options:
#
#    Custom
#    Microsoft
#    Custom with Microsoft available
#
#  The value is immediately committed to AG_P_SBCert.
#
#  Populates:
#    - AG_P_SBCert
# ==============================================================================

sb_certificate()
{
    case "${AG_P_SBCert:-}" in
        "")
            AG_P_SBCert="Custom"
            ;;

        "Custom")
            AG_P_SBCert="Microsoft"
            ;;

        "Microsoft")
            AG_P_SBCert="Custom with Microsoft available"
            ;;

        "Custom with Microsoft available")
            AG_P_SBCert="Custom"
            ;;

        *)
            # Unknown value — reset to the first option.
            AG_P_SBCert="Custom"
            ;;
    esac

    log_silent \
        "SETTER: Secure Boot certificate — AG_P_SBCert=$AG_P_SBCert"
}