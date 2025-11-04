{ pkgs, ... }:
{
  virtualisation.cri-o = {
    enable = true;
  };
  services.kubernetes = {
    enable = true;
    roles = [ "master" ];
  };
}
