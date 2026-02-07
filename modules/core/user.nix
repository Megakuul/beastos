{
  config,
  pkgs,
  theme,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit theme;
      osConfig = config;
    };
    users.${config.beast.profile.username} = {
      imports = [ ./../home ];
      home.username = "${config.beast.profile.username}";
      home.homeDirectory = "/home/${config.beast.profile.username}";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${config.beast.profile.username} = {
    isNormalUser = true;
    description = "${config.beast.profile.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = [ "${config.beast.profile.username}" ];
}
