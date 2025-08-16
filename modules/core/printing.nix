{ pkgs, ... }:
{
  services = {
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns4 = true;
  };
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
