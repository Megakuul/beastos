{
  pkgs,
  hyprsuite,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = hyprsuite.hyprland.packages.${pkgs.system}.default;
    portalPackage =
      hyprsuite.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
