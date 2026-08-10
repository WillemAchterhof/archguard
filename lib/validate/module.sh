#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Validate Module
# ==============================================================================
#  lib/validate/module.sh
# ==============================================================================

shopt -s globstar

for file in "$AG_DIR_VALIDATE"/**/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done

shopt -u globstar