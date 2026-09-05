#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Module
# ==============================================================================
#  lib/postboot/module.sh
#
#  Loads all postboot-stage components.
# ==============================================================================

shopt -s globstar

for file in "$AG_DIR_POSTBOOT"/**/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done

shopt -u globstar