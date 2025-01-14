

{    
  environment.systemPackages = [
    pkgs.emacs
    pkgs.curl
    pkgs.kitty
  ];

  programs = {
    hyprland = {
      enable = true;
    };
  };

  users.users = {
    chief = {
      isNormalUser = true;
      home = "/home/chief";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    }
  };

  networking = {
    hostName = "beastosx";
    firewall.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };
  };

  i18n = {
    consoleKeyMap = "de";
    defaulltLocale = "de_CH.UTF-8";
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

}
