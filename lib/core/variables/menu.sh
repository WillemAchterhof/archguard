#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Menu Runtime State
# ==============================================================================
#  lib/core/variables/menu.sh
#
#  Defines runtime signals used by the menu loop.
#
#  Responsibilities:
#    - Track whether the user chose to proceed or exit
#
#  Set by:
#    - input.sh (handle_input)
#
#  Read by:
#    - lib/menu/run.sh (menu_loop)
#
#  Does NOT:
#    - Store profile configuration
#    - Store hardware detection results
#    - Persist across installer runs
# ==============================================================================

AG_MENU_EXIT="0"
AG_MENU_PROCEED="0"