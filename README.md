# BeastOS 🌹

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
nixos-generate-config --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
```

Create a basic flake that pulls the beast module and configure the options accordingly:

```nix 
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    beastos = {
      url = "github:Megakuul/beastos";
    };
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          inputs.beastos.nixosModules.default
          {
            beast = {
              nixomaticon = true;
              host = "yourhostname123";
              profile = {
                username = "yourname123";
                git = {
                  username = "yourgitname123";
                  email = "yourgitmail@ananas.salat";
                };
              };
            };
          }
        ];
      };
    };
  };
}
```

Enter the environment and install nixos

```bash 
NIX_STORE_DIR=/mnt/nix/store nixos-install --root /mnt --flake /mnt/etc/nixos#desktop
```

Reboot the system and you successfully installed the beast 🎉


> [!TIP]
> You can just add your local nix module to the `modules` list to apply additional configurations to your system.


## Q & A
---

| Question | Answer |
| ------------- | -------------- |
| Where are `.desktop` files mounted? | User: `/etc/profiles/per-user/<username>/share/applications` System: `/run/current-system/sw/share/applications` |

