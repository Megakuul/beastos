{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.vscodium ];
  # home.activation.beforeCheckLinkTargets = {
  #   after = [ ];
  #   before = [ "checkLinkTargets" ];
  #   data = ''
  #     userDir=$HOME/.config/VSCodium/User
  #     rm -rf $userDir/settings.json
  #   '';
  # };

  # home.activation.makeVscodeSettingsMutable = {
  #   after = [ "linkGeneration" ];
  #   before = [ ];
  #   data = ''
  #     userDir=$HOME/.config/VSCodium/User
  #     rm -rf $userDir/settings.json

  #     cp "${
  #       (pkgs.formats.json { }).generate "fck-vscode" config.programs.vscode.profiles.default.userSettings
  #     }" "$userDir/settings.json"

  #     chmod u+w "$userDir/settings.json"
  #   '';
  # };
  # programs.vscode =
  #   let
  #     open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
  #     vscode-marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
  #   in
  #   {
  #     enable = true;
  #     package = pkgs.vscodium;
  #     }
}
