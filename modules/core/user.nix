{
  pkgs,
  username,
  host,
  home,
  stable,
  unstable,
  ...
}: {
  imports = [home.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit username host home stable unstable;};
    users.${username} = {
      imports =
        if (host == "desktop")
        then [./../home/default.desktop.nix]
        else [./../home];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = ["${username}"];
}
