{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "ems_address"
      "ems_article"
      "ems_tenant"
      "ems_global"
      "ems_delivery_note"
      "ems_sales_order"
    ];
    enableTCPIP = true;
    initialScript = pkgs.writeText "init.sql" ''
      alter user postgres with password '1234';
    '';
    settings = {
      port = 5432;
      listen_addresses = pkgs.lib.mkForce "127.0.0.1";
    };
  };
}
