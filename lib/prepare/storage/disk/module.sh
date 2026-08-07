#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Module
# ==============================================================================
#  lib/menu/storage/disk/module.sh
#
#  Loads the disk menu components.
#
#  Responsibilities:
#    - Load disk renderer
#    - Load disk helpers
#
#  Does NOT:
#    - Render menus
#    - Handle user input
#    - Modify installer variables
#    - Source itself
# ==============================================================================

for file in "$SA_DIR_PREPARE/disk"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done