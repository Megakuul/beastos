{ ... }:
{
  imports = [
    ./firefox.nix # use firefox as main browser
    ./brave.nix # brave as chromium backup
    ./git.nix
    ./geany.nix
    ./vscode.nix
  ];
}
