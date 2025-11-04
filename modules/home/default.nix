{...}: {
  imports = [
    ./flex
    ./shell
    ./term
    ./desktop
    ./browser.nix
    ./git.nix
    ./nemo.nix
    ./nvim.nix
    ./packages
    ./rofi.nix
    ./swaylock.nix
    ./swaync/swaync.nix
    ./geany.nix
  ];
}
