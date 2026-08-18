#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — EFI Boot Entry
# ==============================================================================
#  lib/install/boot/efi.sh
#
#  Removes existing EFI boot entries and creates a single Arch Linux entry
#  pointing to the installed UKI.
#
#  Requires:
#    - run_chroot()
#    - AG_P_DISK
#
#  Assumptions:
#    - EFI System Partition is partition 1.
#    - UKI is /boot/EFI/Linux/arch-linux.efi
#
#  Does NOT:
#    - Build the UKI
#    - Sign the UKI
#    - Create Secure Boot keys
#    - Enroll Secure Boot keys
# ==============================================================================

configure_efi_boot()
{
    local boot_entry
    local entries
    local arch_entry

    msg "Configuring EFI boot entries"

    # --------------------------------------------------------------------------
    # Verify UKI
    # --------------------------------------------------------------------------

    run_chroot test -f /boot/EFI/Linux/arch-linux.efi ||
        fatal "UKI not found: /boot/EFI/Linux/arch-linux.efi"

    # --------------------------------------------------------------------------
    # Show current EFI entries
    # --------------------------------------------------------------------------

    msg "Current EFI boot entries"
    run_chroot efibootmgr

    # --------------------------------------------------------------------------
    # Remove all existing EFI boot entries
    #
    # Intentional installer policy:
    #   This system will contain only this Arch installation.
    # --------------------------------------------------------------------------

    msg "Removing existing EFI boot entries"

    entries="$(
        run_chroot efibootmgr |
        awk '
            /^Boot[0-9A-Fa-f]{4}/ {
                entry=$1
                sub(/^Boot/, "", entry)
                sub(/\*.*/, "", entry)
                print entry
            }
        '
    )" || true

    while IFS= read -r boot_entry; do
        [[ -n "$boot_entry" ]] || continue

        msg "Removing EFI entry: Boot$boot_entry"

        run_chroot efibootmgr \
            -b "$boot_entry" \
            -B ||
            fatal "Failed to remove EFI entry: Boot$boot_entry"

    done <<< "$entries"

    # --------------------------------------------------------------------------
    # Create Arch Linux EFI entry
    # --------------------------------------------------------------------------

    msg "Creating Arch Linux EFI entry"

    run_chroot efibootmgr \
        --create \
        --disk "$AG_P_DISK" \
        --part 1 \
        --label "Arch Linux" \
        --loader '\EFI\Linux\arch-linux.efi' \
        --unicode ||
        fatal "Failed to create Arch Linux EFI entry"

    # --------------------------------------------------------------------------
    # Find the newly-created Arch entry
    # --------------------------------------------------------------------------

    arch_entry="$(
        run_chroot efibootmgr |
        awk '
            /Arch Linux/ {
                entry=$1
                sub(/^Boot/, "", entry)
                sub(/\*.*/, "", entry)
                print entry
                exit
            }
        '
    )"

    [[ -n "$arch_entry" ]] ||
        fatal "Could not find newly-created Arch Linux EFI entry"

    # --------------------------------------------------------------------------
    # Set boot order
    # --------------------------------------------------------------------------

    msg "Setting boot order: Boot$arch_entry"

    run_chroot efibootmgr \
        -o "$arch_entry" ||
        fatal "Failed to set EFI boot order"

    # --------------------------------------------------------------------------
    # Final verification
    # --------------------------------------------------------------------------

    msg "EFI boot configuration"

    run_chroot efibootmgr

    msg "EFI boot entry configured"
}