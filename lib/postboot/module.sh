#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Module
# ==============================================================================
#  lib/postboot/module.sh
#
#  Loads postboot preparation components.
# ==============================================================================

for file in "$AG_DIR_POSTBOOT/prepare"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue

    source "$file"
done