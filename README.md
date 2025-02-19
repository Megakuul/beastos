# BEASTOS
---

My personal nixos configuration. Don't copy this repo; use it as inspiration. Many things are hardcoded to my specific requirements!

*TODO: Write detailled description*

Install beastos with the following steps:

- Setup root partition (`/dev/disk/by-label/NIXROOT` or `/dev/mapper/cryptroot`) and mount at `/mnt`.
- Setup boot partition (`/dev/disk/by-label/NIXBOOT`) and mount at `/mnt/boot`.
- Generate NixOS config with `nixos-generate-config --root /mnt`.
- Correct generated `hardware-configuration.nix` at `/mnt/etc/nixos` to match with the actual disk uuids or labels.
- Add grub to the generated `configuration.nix` at `/mnt/etc/nixos`:
```nix
boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
  efiInstallAsRemovable = true;
};
```
- Git clone this repository and put the content into `/nix/persist/etc/nixos` (currently desktop-01 still uses legacy configs, its configuration is located at /etc/nixos).
- Create a dummy splashscreen for initial setup `touch /etc/nixos/boot-splash-image.jpg`.
- Install the system with `nixos-install` and reboot.
- After reboot use `nixos-rebuild boot --flake /nix/persist/etc/nixos#<desired device>` and reboot again.
