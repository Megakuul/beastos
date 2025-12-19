{
  config,
  pkgs,
  ...
}: {
  networking = {
    hostName = "${config.beast.host}";
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
    nftables.enable = true;
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
