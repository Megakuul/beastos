{ pkgs, ... }:
{
  fileSystems."/mnt/phonebook" = {
    device = "//10.1.1.17/phonebook";
    fsType = "cifs";
    options = [
      "guest"
      "iocharset=utf8"
      "x-systemd.automount,noauto,x-systemd.idle-timeout=60"
    ];
  };
}
