# Nixomaticon

![informli](/favicon.svg)

Basically just a superior operating system for work.

## Installation
---

**1. Download and burn nixos iso:**

```bash
wget 
dd if=./nixos of=/dev/sdx --status=progress
```

**2. Boot into iso and setup your disks**

```bash
# setup boot part with at least EFI part (500mb) + Linux part (rest)
fdisk /dev/nvme0n1

# configure luks on Linux part
cryptsetup /dev/nvme0n1p2
cryptopen /dev/nvme0n1p2 cryptmapper

# setup filesystems
mkfs.ext4 -L NIXROOT /dev/nvme0n1p2
mount /dev/disk/by-label/NIXROOT /mnt

mkfs.fat -F 32 /dev/nvme0n1p1
fatlabel NIXBOOT /dev/nvme0n1p1
mount /dev/disk/by-label/NIXBOOT /mnt/boot --mkdir
```

**3. Create your flake and install nixos**

```bash 
mkdir -p /mnt/etc/nixos
vim /mnt/etc/nixos/flake.nix
```

Create a basic flake that pulls the nixomaticon flake:

```nix 

```

Enter the environment and install nixos

```bash 
NIX_STORE_DIR=/mnt/nix/store nixos-install --root /mnt --flake /mnt/etc/nixos#desktop
```

Reboot the system and you successfully installed nixomaticon


## Q & A
---

| Question | Answer |
| ------------- | -------------- |
| Where are `.desktop` files mounted? | User: `/etc/profiles/per-user/<username>/share/applications` System: `/run/current-system/sw/share/applications` |

