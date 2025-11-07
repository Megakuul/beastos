{pkgs, ...}: {
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    efiInstallAsRemovable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];
}
