#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Menu Module
# ==============================================================================
#  lib/menu/module.sh
#
#  Loads the menu-stage components.
#
#  Responsibilities:
#    - Load menu renderer
#    - Load input dispatcher
#
#  Does NOT:
#    - Render menus
#    - Handle user input
#    - Source itself
# ==============================================================================

for file in "$AG_DIR_MENU"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done