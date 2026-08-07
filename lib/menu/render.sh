#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Main Renderer
# ==============================================================================
#  lib/menu/render.sh
# ==============================================================================

render_menu()
{
    format_hardware
    
    clear

    printf "================================================================================\n"
    printf " Arch Secure Installer\n"
    printf "================================================================================\n\n"

    printf " Profile : %s\n" "${AG_PROFILE_NAME:-Default}"

    printf " Hardware\n"
    printf "   CPU         : %s\n" "$AG_HW_CPU_NAME"
    printf "   GPU         : %s\n" "$AG_HW_GPU_MODEL"
    printf "   Boot Mode   : %s\n" "${AG_HW_BOOT_MODE^^}"
    printf "   Secure Boot : %s\n" "$AG_DISPLAY_SB"
    printf "   TPM         : %s\n" "$AG_DISPLAY_TPM"

    printf "   Memory      : %s GB\n" "$AG_HW_MEMORY_TOTAL_GB"
    printf "\n"

    printf " Storage\n"
    printf "   [a] Disk        : %s\n" "${AG_P_TARGET_DISK:-Not set}"
    printf "   [b] Filesystem  : %s\n" "${AG_P_ROOT_FS:-Not set}"
    printf "   [c] EFI         : %s\n" "${AG_P_EFI_SIZE:-Not set}"
    printf "   [d] Swap        : %s\n" "${AG_P_SWAP_STATUS:-Not set}"
    printf "\n"
    
    printf " Security\n"
    printf "   [e] LUKS        : %s\n" "${AG_P_LUKS:-Not set}"
    printf "   [f] Secure Boot : %s\n" "${AG_P_SECUREBOOT:-Not set}"
    printf "   [g] Wipe        : %s\n" "${AG_P_DISK_WIPE_MODE:-Not set}"
    printf "\n"

    printf " System\n"
    printf "   [h] Hostname    : %s\n" "${AG_P_HOSTNAME:-Not set}"
    printf "   [i] Username    : %s\n" "${AG_P_USERNAME:-Not set}"
    printf "   [l] Locale      : %s\n" "${AG_P_LOCALE:-Not set}"
    printf "   [m] Timezone    : %s\n" "${AG_P_TIMEZONE:-Not set}"
    printf "   [n] Keyboard    : %s\n" "${AG_P_KEYBOARD:-Not set}"
    printf "   [o] Mirrors     : %s\n" "${AG_P_MIRROR_COUNTRIES:-Not set}"
    printf "   [p] Pacman      : %s parallel downloads\n" "${AG_P_PACMAN_PARALLEL:-Not set}"
    printf "\n"

    printf " Actions\n"
    printf " ────────────────────────────────────────────────────────────────────────────────\n"    
    printf "  [w] Load profile    [x] Save profile    [y] Install    [z] Exit\n\n"
    printf "\n"
    printf "================================================================================\n"
}
