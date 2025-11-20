{
  pkgs,
  theme,
  ...
}: {
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    efiInstallAsRemovable = true;
    useOSProber = true;
    splashImage = theme.bootloader;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];
}
