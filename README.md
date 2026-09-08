# ArchGuard

**ArchGuard** is a security-focused Arch Linux installation and hardening framework.

It is designed around a simple principle:

> **Build a minimal Arch Linux system, establish a measured and trusted boot chain, reduce the attack surface, isolate applications and virtual machines, and make security-relevant changes visible to the user.**

ArchGuard is not intended to be a universal "secure Arch" configuration. It is a deliberately opinionated system with hardware-aware configuration, explicit security decisions, and a strong focus on measured boot, encryption, network isolation, and runtime confinement.

---

## Security Architecture

ArchGuard is organized into the following security layers:

```text
0. Hardware / Firmware
        │
        ▼
1. Boot Integrity
        │
        ▼
2. Secrets & Storage
        │
        ▼
3. Kernel Security
        │
        ▼
4. Network Security
        │
        ▼
5. Services & Privileges
        │
        ▼
6. Application Confinement
        │
        ▼
7. Virtualization Isolation
        │
        ▼
8. Detection & Response
```

The layers are intentionally separated so that each security boundary has a clear responsibility.

---

# 0. Hardware / Firmware

ArchGuard assumes a modern UEFI system with TPM 2.0 support.

The firmware layer provides the root of trust for the measured boot chain.

Primary goals:

* UEFI boot
* Secure Boot
* TPM 2.0
* measured boot
* hardware-aware configuration
* detection of security-relevant hardware or firmware changes

ArchGuard does not assume that the TPM itself makes a system secure.

The TPM is used as part of a larger chain of trust.

---

# 1. Boot Integrity

ArchGuard uses a **Unified Kernel Image (UKI)** and Secure Boot.

The intended boot chain is:

```text
UEFI
 │
 ├── Secure Boot
 │
 ▼
Signed UKI
 │
 ├── Kernel
 ├── initrd
 └── kernel command line
 │
 ▼
Measured boot
 │
 ▼
TPM 2.0
```

The system uses `systemd-stub` to boot the UKI.

ArchGuard does not rely on a traditional installed systemd-boot configuration when direct UKI boot entries are used.

### Kernel lockdown

ArchGuard enables:

```text
lockdown=confidentiality
```

This provides a stronger kernel security boundary when Secure Boot is active.

An intentional consequence is that **kernel hibernation is not supported** under this security model.

Suspend remains possible.

---

# 2. Secrets & Storage

ArchGuard uses:

* LUKS2
* encrypted root storage
* LVM where appropriate
* encrypted swap
* TPM 2.0 automatic unlock
* TPM PIN protection

The TPM is not treated as a replacement for the LUKS passphrase.

The intended model is:

```text
TPM measurements
       +
TPM PIN
       +
LUKS
       ↓
Encrypted system
```

## TPM PCR policy

The current TPM enrollment uses:

```text
PCR 0
PCR 1
PCR 2
PCR 4
PCR 5
PCR 7
PCR 12
```

with SHA-256 measurements.

PCR 11 is handled through a **signed PCR policy** rather than being included directly in the raw PCR binding.

This allows ArchGuard to use systemd's PCR-phase measurements without treating every legitimate PCR-11 change as a completely new raw PCR value.

The current enrollment model uses:

```text
TPM 2.0
+ TPM PIN
+ PCR policy
+ signed PCR-11 policy
+ LUKS2
```

## No automatic TPM re-enrollment

ArchGuard deliberately does **not** automatically re-enroll the TPM after security-relevant changes.

If the measured boot state changes unexpectedly:

```text
TPM unlock fails
        │
        ▼
Manual LUKS unlock
        │
        ▼
ArchGuard detects changed state
        │
        ▼
Network quarantine
        │
        ▼
User investigates
        │
        ▼
Explicit approval
        │
        ▼
Manual TPM re-enrollment
```

This is intentional.

Automatic re-enrollment could turn a potentially suspicious change into an automatically trusted state.

---

# 3. Kernel Security

ArchGuard applies several kernel-level hardening measures.

Current security decisions include:

* kernel lockdown
* module signature enforcement
* hardware-aware module minimization
* disabled kexec loading
* restricted unprivileged BPF
* BPF LSM
* restricted performance counters
* restricted kernel pointer exposure
* restricted kernel message access
* Yama
* AppArmor
* Landlock
* ASLR-related hardening
* personal kernel module blacklist

The exact configuration is intentionally kept in ArchGuard's configuration files rather than hard-coded throughout the installer.

## Module minimization

ArchGuard does not use a universal "blacklist every dangerous module" policy.

Instead, it supports a **hardware- and usage-specific blacklist**.

For example, a machine that does not contain or require:

* FireWire
* Thunderbolt
* floppy controllers
* legacy serial hardware
* optical drives
* legacy ATA controllers
* unused filesystems
* unused network protocols

can disable those modules.

The important distinction is:

> **Unused hardware is reduced deliberately; required hardware is not disabled merely because a module could theoretically be abused.**

The blacklist is therefore considered a personal/hardware-specific configuration.

USB device authorization is handled separately by USBGuard.

---

# 4. Network Security

ArchGuard uses **nftables** as the primary host firewall.

The firewall is designed around explicit trust boundaries rather than simply allowing all local traffic.

The intended model for the host and virtual machines is:

```text
                         Internet
                            │
                            │
                         DENY
                            │
                            ▼
                     ┌─────────────┐
                     │    Host     │
                     └─────────────┘
                       ▲         │
                 DENY  │         │ ALLOW
                       │         ▼
                  ┌──────────────────┐
                  │   Virtual Net    │
                  │     virbr0       │
                  └──────────────────┘
                       │         ▲
                       │         │
                     ALLOW      ALLOW
                       │         │
                       ▼         │
                     Internet    Host
```

More explicitly:

| Traffic         | Policy |
| --------------- | ------ |
| Internet → Host | DENY   |
| VM → Host       | DENY   |
| Host → VM       | ALLOW  |
| VM → Internet   | ALLOW  |
| Internet → VM   | DENY   |
| VM → VM         | DENY   |

VM traffic is NATed through the host.

The default VM subnet is:

```text
192.168.122.0/24
```

ArchGuard owns its own nftables tables.

It does **not** globally flush the nftables ruleset because doing so could interfere with other software such as libvirt.

The intended ownership model is:

```text
ArchGuard
 ├── archguard_filter
 └── archguard_nat

libvirt
 └── libvirt-owned nftables rules
```

This separation is intentional.

---

# DNS

ArchGuard treats DNS as part of the network security layer.

The intended design is for the system/network layer to own DNS policy.

Applications should not silently bypass this policy using their own DNS-over-HTTPS configuration.

For example, Firefox is configured with:

```text
DNS over HTTPS: OFF
```

This allows the system's DNS policy to remain authoritative.

---

# 5. Services & Privileges

ArchGuard attempts to keep the installed system minimal.

Services should only be enabled when they are actually required.

The base system includes components needed for:

* networking
* Bluetooth
* audio
* storage management
* authentication/policy
* firewalling
* security tooling
* system administration

Examples include:

```text
NetworkManager
iwd
bluez
PipeWire
WirePlumber
udisks2
polkit
nftables
sudo
```

Service enablement is separated from static configuration deployment.

Static configuration files belong in:

```text
install/configs/
```

Runtime and first-boot actions belong in:

```text
install/lib/postboot/
```

This distinction prevents configuration files from becoming mixed with installer logic.

---

# 6. Application Confinement

ArchGuard uses Linux security mechanisms including:

* AppArmor
* Landlock
* kernel lockdown
* systemd service hardening
* filesystem permissions
* sandboxing where available

The goal is not to assume that every installed application is trustworthy.

Instead:

> **Applications should have only the privileges and access they actually need.**

## Firefox

The Firefox baseline uses:

* Enhanced Tracking Protection: Strict
* HTTPS-Only Mode
* DNS-over-HTTPS disabled
* Firefox password storage disabled
* DuckDuckGo as the default search engine
* search suggestions disabled
* unwanted recommendations disabled
* unnecessary data collection disabled
* automatic updates enabled

Installed privacy extensions include:

* uBlock Origin
* I Still Don't Care About Cookies
* Multi-Account Containers
* Temporary Containers

uBlock Origin is configured with multiple maintained filtering lists for advertising, tracking, malware, cookies, social widgets, and annoyances.

---

# Package Trust Model

ArchGuard prefers software from the official Arch repositories.

The intended trust hierarchy is:

```text
Official Arch repositories
        │
        │ preferred
        ▼
       AUR
        │
        │ user-reviewed
        ▼
     Flatpak
        │
        │ permission-reviewed
        ▼
Random binary repositories
        │
        │ avoid
        ▼
curl | sh installers
```

## Official repositories

Official Arch packages use package signature verification.

ArchGuard does not disable package signature verification as a workaround for installation problems.

## AUR

The AUR contains user-produced build instructions.

AUR packages are therefore treated as a lower-trust source.

Users should inspect:

* `PKGBUILD`
* source files
* install scripts
* dependencies
* build commands

before installing an AUR package.

## Flatpak

Flatpak is useful for desktop applications because applications can run inside a sandbox.

However, Flatpak permissions still matter.

A Flatpak application with broad filesystem, device, or network permissions should not be treated as strongly isolated merely because it is distributed as a Flatpak.

---

# USBGuard

USBGuard provides device-level USB authorization.

The intended architecture is:

```text
USB hardware
     │
     ▼
Linux USB subsystem
     │
     ▼
USBGuard
     │
     ├── authorized device
     │
     └── blocked device
```

ArchGuard generates an initial USBGuard policy from the devices connected during installation/postboot.

USBGuard is enabled only after the initial policy has been generated.

This is intended to avoid accidentally locking out the keyboard and mouse during first activation.

USB device control is separate from the kernel module blacklist.

---

# Virtualization

ArchGuard supports KVM/QEMU/libvirt for occasional Windows or Linux virtual machines.

The preferred virtual machine architecture uses:

* KVM
* QEMU
* libvirt
* virt-manager
* UEFI
* Q35 machine type
* TPM 2.0
* VirtIO devices
* Secure Boot where supported
* isolated VM networking

For Windows guests, VirtIO drivers should be installed in the guest when required.

## VM isolation

ArchGuard intentionally avoids unnecessary host/guest integration.

For example, host filesystem sharing should not be enabled unless there is a specific requirement.

A VM should not automatically receive access to:

```text
/home
SSH keys
browser profiles
password stores
personal documents
host sockets
```

USB passthrough should be explicit rather than automatically exposing host USB devices to guests.

---

# Postboot Architecture

ArchGuard separates installation from first-boot configuration.

The general flow is:

```text
Arch ISO
   │
   ▼
Installation
   │
   ├── partitioning
   ├── LUKS
   ├── LVM
   ├── filesystem
   ├── pacstrap
   ├── kernel
   ├── UKI
   ├── Secure Boot
   └── configuration deployment
   │
   ▼
Reboot
   │
   ▼
Installed system
   │
   ▼
Postboot
   │
   ├── temporary configuration
   ├── USBGuard
   ├── TPM enrollment
   ├── verification
   └── cleanup
   │
   ▼
Normal system
```

Temporary installation state is removed after it has served its purpose.

The postboot environment is stored temporarily under:

```text
/opt/archguard
```

and is removed when postboot processing is complete.

---

# Temporary Wi-Fi Configuration

Wi-Fi credentials may be collected during installation when required.

The temporary flow is:

```text
Installer
   │
   ▼
state/config/wifi.env
   │
   ▼
Target system
/opt/archguard/state/config/wifi.env
   │
   ▼
NetworkManager
   │
   ▼
Wi-Fi connection
   │
   ▼
Temporary credentials removed
   │
   ▼
/opt/archguard removed
```

The temporary Wi-Fi file is protected with restrictive permissions.

The password is unset from the installer shell after it has been written.

ArchGuard does not intend to leave the installer credential file permanently installed on the final system.

---

# Backup / Recovery Philosophy

ArchGuard does not currently install Timeshift as part of the default security baseline.

The recovery strategy is intentionally simple:

```text
Broken system
     │
     ▼
Boot ArchGuard installer
     │
     ▼
Reinstall
```

This avoids adding another snapshot/backup subsystem to the default installation.

Users who require additional backup infrastructure can add it independently.

Backups of personal data remain the user's responsibility.

---

# Filesystem Layout

The project separates installer code, configuration, state, and runtime actions.

Current structure:

```text
archguard/
├── install/
│   ├── configs/
│   │   └── system/
│   │
│   ├── lib/
│   │   ├── core/
│   │   │   ├── logging/
│   │   │   ├── precheck/
│   │   │   ├── profile/
│   │   │   ├── services/
│   │   │   └── variables/
│   │   │
│   │   ├── install/
│   │   │
│   │   ├── menu/
│   │   │
│   │   ├── prepare/
│   │   │
│   │   ├── postboot/
│   │   │
│   │   ├── utilities/
│   │   │
│   │   └── validate/
│   │
│   └── orchestrator/
│
└── state/
    ├── config/
    └── log/
```

## Configuration ownership

Static configuration:

```text
install/configs/
```

Installer logic:

```text
install/lib/
```

Runtime/first-boot actions:

```text
install/lib/postboot/
```

Temporary installer state:

```text
state/
```

This separation is intentional.

---

# Hardware Awareness

ArchGuard detects hardware during installation.

Current hardware-aware areas include:

* CPU vendor
* GPU vendor
* network interfaces
* storage devices
* filesystem requirements
* kernel module requirements

For example:

```text
Intel CPU → intel-ucode

AMD CPU → amd-ucode
```

GPU packages are selected according to detected hardware.

The installer should not install unnecessary hardware-specific packages merely because they exist.

---

# Current Security Decisions

The following decisions are intentional parts of the ArchGuard security model.

| Area                        | Decision                 |
| --------------------------- | ------------------------ |
| Secure Boot                 | Enabled                  |
| UKI                         | Enabled                  |
| TPM 2.0                     | Required/used            |
| LUKS2                       | Enabled                  |
| TPM PIN                     | Enabled                  |
| TPM PCR policy              | Enabled                  |
| Automatic TPM re-enrollment | Disabled                 |
| Kernel lockdown             | `confidentiality`        |
| Module signatures           | Enabled                  |
| kexec                       | Disabled                 |
| Unprivileged BPF            | Restricted               |
| BPF LSM                     | Enabled                  |
| perf events                 | Restricted               |
| AppArmor                    | Enabled                  |
| Landlock                    | Enabled                  |
| Yama                        | Enabled                  |
| nftables                    | Enabled                  |
| USBGuard                    | Enabled                  |
| VM isolation                | Enabled                  |
| Global kernel blacklist     | No                       |
| Hardware-specific blacklist | Yes                      |
| Hibernation                 | Unsupported              |
| Suspend                     | Supported                |
| Timeshift                   | Not installed by default |
| Firefox DoH                 | Disabled                 |
| Official Arch packages      | Preferred                |
| AUR                         | User-reviewed            |
| Flatpak                     | Permission-reviewed      |

---

# Threat Model

ArchGuard is primarily designed to reduce the impact of:

* malicious removable devices
* unauthorized USB devices
* boot-chain tampering
* modified firmware/boot state
* offline attacks against the encrypted system
* malicious or compromised applications
* unnecessary kernel attack surface
* unauthorized network access
* VM-to-host attacks
* VM-to-VM lateral movement
* accidental exposure of host resources
* persistence through unnecessary services

ArchGuard does **not** claim to protect against every possible attack.

In particular, it cannot magically protect a system from:

* a compromised firmware supply chain
* a physically compromised TPM
* an already-compromised trusted boot chain
* malicious hardware that is intentionally authorized
* stolen credentials
* a user intentionally granting dangerous application permissions
* vulnerabilities that have not yet been discovered
* a sufficiently privileged attacker who has already obtained complete control of the system

Security is therefore treated as a layered system rather than a single feature.

---

# Design Philosophy

ArchGuard follows several principles.

### 1. Explicit trust

Do not silently turn an unexpected state into a trusted state.

### 2. Least privilege

Install and enable only what is required.

### 3. Layered security

No individual security mechanism should be considered sufficient by itself.

### 4. Hardware awareness

Do not disable hardware blindly for theoretical security benefits.

### 5. Separation of responsibilities

Configuration, installation logic, runtime actions, and temporary state should remain separate.

### 6. Fail closed where practical

Unexpected security states should result in denial, quarantine, or a clear warning rather than silent acceptance.

### 7. Keep the system understandable

Security should not depend on an enormous collection of unexplained tweaks.

### 8. Prefer upstream mechanisms

Where possible, ArchGuard uses established Linux security mechanisms rather than inventing replacements.

---

# Testing

ArchGuard is tested both in:

* a KVM/libvirt virtual machine
* physical hardware

Virtual machines are useful for validating:

* installation flow
* partitioning
* filesystem configuration
* networking
* UKI generation
* Secure Boot configuration
* TPM behavior
* postboot execution
* firewall behavior
* service configuration

Physical hardware remains necessary for validating:

* real firmware behavior
* Secure Boot
* TPM measurements
* actual GPU operation
* Wi-Fi
* Bluetooth
* USB devices
* suspend
* display manager
* hardware-specific kernel modules

A configuration that works in a VM should not automatically be considered validated on physical hardware.

---

# Development Principles

ArchGuard is intentionally built as a collection of small components rather than one enormous installer script.

Functions should have a single clear responsibility.

For example:

```text
detect_cpu
detect_gpu
configure_disk
deploy_configs
usbguard_install
usbguard_policy
usbguard_turn_on
enroll_tpm
verify_tpm
clean_postboot
```

The orchestrator should determine **when** operations happen.

Individual modules should determine **how** they perform their specific task.

---

# Project Status

ArchGuard is an actively developed personal security-focused Arch Linux installer.

The following areas are operational or substantially implemented:

* UEFI installation
* Secure Boot
* UKI boot
* TPM 2.0
* LUKS2
* LVM
* TPM-based LUKS unlock
* TPM PIN
* PCR-based policy
* kernel lockdown
* kernel hardening
* nftables
* AppArmor
* NetworkManager
* Plasma
* SDDM
* Bluetooth/audio stack
* KVM/libvirt support
* Firefox security baseline
* postboot cleanup

Some components remain under active development and validation.

Do not assume that an option described in this README is universally appropriate for every Arch Linux installation.

---

# Disclaimer

ArchGuard is a personal security project.

It is **not** a security certification, hardened distribution, or guarantee of system security.

Security settings can cause compatibility problems, prevent hardware from working, or make legitimate system changes require manual intervention.

Always test ArchGuard on hardware you control before relying on it for important systems.

Keep independent backups of important data.

---

# License

License: **TBD**

Until a license is explicitly selected, the project should not be assumed to grant broad redistribution or modification rights.

---
