{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports =
        if (host == "desktop") then
          [ ./../home/default.desktop.nix ]
        else
          [ ./../home ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.sessionVariables = {
        PATH = "$HOME/.local/bin:$PATH";
        EDITOR = "nvim";
      };
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
  nix.settings.allowed-users = [ "${username}" ];
}
