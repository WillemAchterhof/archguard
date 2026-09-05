#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — UKI PCR Signature Config
# ==============================================================================
#  lib/install/boot/uki_conf.sh
#
#  Writes /etc/kernel/uki.conf so mkinitcpio's ukify integration signs the
#  expected TPM2 PCR policy into the UKI on every build (initial and every
#  kernel update).
#
#  Secure Boot signing itself is NOT configured here — that's handled
#  separately by sbctl (see sign_uki.sh / the zz-sbctl-uki.hook pacman
#  hook), so no [UKI] SecureBootPrivateKey/-Certificate fields are set;
#  adding them here would create a second, competing signing path.
#
#  Requires:
#    - run_chroot()
#
#  Does NOT:
#    - Generate the PCR signing keys (see pcr_keys.sh)
#    - Sign for Secure Boot
#    - Build the UKI
# ==============================================================================

configure_uki_conf()
{
    msg "Configuring UKI PCR signature policy"

    run_chroot mkdir -p /etc/kernel

    run_chroot tee /etc/kernel/uki.conf >/dev/null <<'EOF'
[PCRSignature:all]
PCRPrivateKey=/etc/systemd/tpm2-pcr-private-key.pem
PCRPublicKey=/etc/systemd/tpm2-pcr-public-key.pem

[PCRSignature:initrd]
Phases=enter-initrd
PCRPrivateKey=/etc/systemd/tpm2-pcr-private-key-initrd.pem
PCRPublicKey=/etc/systemd/tpm2-pcr-public-key-initrd.pem
EOF

    msg "UKI PCR signature policy configured"
}