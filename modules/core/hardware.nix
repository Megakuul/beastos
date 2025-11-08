{pkgs, ...}: let
  hyprland-pkgs = pkgs.hyprland.nixpkgs;
in {
  hardware = {
    graphics = {
      enable = true;
      package = pkgs.mesa;
      extraPackages = with pkgs; [
        intel-media-driver
        (intel-vaapi-driver.override {enableHybridCodec = true;})
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
  hardware.enableRedistributableFirmware = true;
}
