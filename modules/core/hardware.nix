{
  pkgs,
  hyprsuite,
  ...
}: let
  hyprland-pkgs =
    hyprsuite.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  hardware = {
    graphics = {
      enable = true;
      package = hyprland-pkgs.mesa;
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
