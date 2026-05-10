{
  config,
  pkgs,
  ...
}: {
  users.users.${config.beast.profile.username}.extraGroups = [
    "libvirtd"
    "docker"
    "incus-admin"
  ];

  environment.systemPackages = with pkgs; [
    virtio-win
    win-spice
  ];

  virtualisation = {
    docker = {
      enable = true;
    };
    waydroid.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [virtiofsd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
