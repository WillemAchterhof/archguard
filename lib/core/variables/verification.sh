#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Verification State
# ==============================================================================
#  lib/core/variables/verification.sh
#
#  Defines one flag per field checked by lib/validate/*. These never
#  hold data — only a pass/fail judgment about the matching AG_P_*
#  value. render_menu reads them to decide what to print; nothing
#  else should.
#
#  Values:
#    "0" — valid
#    "1" — invalid
#
#  Set by:
#    - lib/validate/validate_*.sh
#
#  Read by:
#    - lib/menu/render.sh
#
#  Does NOT:
#    - Store profile configuration (see AG_P_*)
#    - Persist across installer runs
# ==============================================================================
 
AG_V_DISK="0"
AG_V_EFI="0"
AG_V_FILESYSTEM="0"
AG_V_VOLUMES="0"
AG_V_LUKS="0"
AG_V_SWAP="0"
AG_V_WIPE="0"
