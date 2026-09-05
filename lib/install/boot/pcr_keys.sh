#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — PCR Signing Keys
# ==============================================================================
#  lib/install/boot/pcr_keys.sh
#
#  Generates the persistent keypairs used to sign the expected TPM2 PCR
#  policy into every UKI build (see uki_conf.sh). Signing (rather than
#  binding to a raw PCR value) means a rebuilt UKI after a kernel update
#  keeps unlocking without re-enrolling in systemd-cryptenroll, as long as
#  these keys stay in place.
#
#  Requires:
#    - run_chroot()
#
#  Does NOT:
#    - Configure uki.conf
#    - Build or sign the UKI
#    - Enroll the LUKS volume
# ==============================================================================

create_pcr_keys()
{
    msg "Generating PCR signing keys"

    run_chroot pacman -S \
        --noconfirm \
        --needed \
        systemd-ukify

    run_chroot ukify genkey \
        --pcr-private-key=/etc/systemd/tpm2-pcr-private-key.pem \
        --pcr-public-key=/etc/systemd/tpm2-pcr-public-key.pem

    run_chroot ukify genkey \
        --pcr-private-key=/etc/systemd/tpm2-pcr-private-key-initrd.pem \
        --pcr-public-key=/etc/systemd/tpm2-pcr-public-key-initrd.pem

    run_chroot chmod 600 \
        /etc/systemd/tpm2-pcr-private-key.pem \
        /etc/systemd/tpm2-pcr-private-key-initrd.pem

    msg "PCR signing keys generated"
}