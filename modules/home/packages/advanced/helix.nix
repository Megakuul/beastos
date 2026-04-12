{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      theme = "catppuccin_mocha";
      keys.insert = {
        "j" = {
          "k" = "normal_mode";
        };
      };
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
        };
        lsp.display-messages = true;
      };
    };
  };
}
