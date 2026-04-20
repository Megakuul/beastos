{ pkgs, ... }:

{
  home.packages = with pkgs; [ yazi ];
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    languages = {
      language-server.gopls = {
        command = "gopls";
        config = {
          "gofumpt" = true;
          "local" = "goimports";
          "semanticTokens" = true;
          "staticcheck" = true;
          "verboseOutput" = true;
          source = {
            organizeImports = "explicit";
          };
          "analyses" = {
            "fieldalignment" = true;
            "nilness" = true;
            unusedparams = true;
            unusedwrite = true;
            useany = true;
          };
          usePlaceholders = true;
          completeUnimported = true;
          hints = {
            "assignVariableType" = true;
            "compositeLiteralFields" = true;
            "compositeLiteralTypes" = true;
            "constantValues" = true;
            "functionTypeParameters" = true;
            "parameterNames" = true;
            "rangeVariableTypes" = true;
          };
        };
      };
      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = ["gopls"];
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
