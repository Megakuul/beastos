{ pkgs, ... }:

{
  home.packages = with pkgs; [ yazi ];
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    languages = {
      language = [
        {
          name = "go";
          auto-format = true;
          formatter = {
            command = "${pkgs.gotools}/bin/goimports";
          };
        }
      ];
    };
    settings = {
      theme = "catppuccin_mocha";
      keys.normal = {
        "ö" = "expand_selection";
      };
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
