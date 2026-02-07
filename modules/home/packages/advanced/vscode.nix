{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        vscodevim.vim
        eamodio.gitlens
        golang.go
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        jeff-hykin.better-nix-syntax
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        enkia.tokyo-night
        vscode-icons-team.vscode-icons

        sumneko.lua
        esbenp.prettier-vscode
        llvm-vs-code-extensions.vscode-clangd
        ocamllabs.ocaml-platform
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        ms-python.python
        charliermarsh.ruff
        mads-hartmann.bash-ide-vscode
        elijah-potter.harper
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "oil-code";
          publisher = "haphazarddev";
          version = "0.0.33";
          sha256 = "sha256-lJcB8cc8ht7/AqIDcNSB4MDlsK9/ZX3ds7Rn8adVU68=";
        }
      ];

    profiles.default.keybindings = [
      {
        key = "ctrl+n";
        command = "editor.action.fontZoomIn";
      }
      {
        key = "ctrl+m";
        command = "editor.action.fontZoomOut";
      }
      {
        key = "ctrl+b";
        command = "editor.action.fontZoomReset";
      }
      {
        key = "ctrl+f";
        command = "workbench.action.focusActiveEditorGroup";
        when = "sideBarFocus || terminalFocus";
      }
      {
        key = "ctrl+t";
        command = "workbench.action.terminal.focus";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+t";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "ctrl+shift+t";
        command = "workbench.action.terminal.new";
        when = "terminalFocus";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.nextEditor";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.previousEditor";
      }
      {
        key = "ctrl+j";
        command = "workbench.action.terminal.focusNext";
        when = "terminalFocus";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.terminal.focusPrevious";
        when = "terminalFocus";
      }
      {
        key = "tab";
        command = "selectNextSuggestion";
        when = "suggestWidgetVisible";
      }
      {
        key = "shift+tab";
        command = "selectPrevSuggestion";
        when = "suggestWidgetVisible";
      }
      {
        key = "tab";
        command = "-acceptSelectedSuggestion";
        when = "suggestWidgetVisible";
      }
      {
        key = "ctrl+q";
        command = "workbench.action.navigateBack";
        when = "canNavigateBack";
      }
      {
        key = "ctrl+x";
        command = "-cut";
      }
      {
        key = "ctrl+x";
        command = "workbench.action.terminal.kill";
        when = "terminalFocus";
      }
      {
        key = "ctrl+x";
        command = "workbench.action.closeActiveEditor";
        when = "!terminalFocus";
      }
      {
        key = "ctrl+q";
        command = "workbench.action.navigateForward";
        when = "!canNavigateBack";
      }
      {
        key = "enter";
        command = "runCommands";
        args = {
          commands = [
            "closeFindWidget"
            "cursorLeft"
          ];
        };
        when = "findWidgetVisible && !isComposing";
      }
      {
        key = "ctrl+z";
        command = "workbench.action.toggleZenMode";
      }
      {
        key = "ctrl+z";
        command = "-undo";
      }
    ];

    profiles.default.userSettings = {
      "workbench.iconTheme" = "vscode-icons";
      "svelte.enable-ts-plugin" = true;
      "zenMode.fullScreen" = false;
      "zenMode.centerLayout" = false;
      "zenMode.hideTabs" = false;
      "zenMode.hideLineNumbers" = false;
      "editor.tabSize" = 2;
      "editor.lineNumbers" = "relative";
      "editor.fontWeight" = "500";
      "editor.fontSize" = 18;
      "editor.lineHeight" = 1.2;
      "editor.fontFamily" =
        "'IosevkaTerm Nerd Font', 'Iosevka Term', 'Iosevka', 'JetBrainsMono Nerd Font', monospace";
      "editor.fontLigatures" = true;
      "editor.accessibilitySupport" = "off";
      "editor.hover.enabled" = "onKeyboardModifier";
      "editor.hover.sticky" = true;
      "problems.showCurrentInStatus" = true;
      "oil-code.disableDefaultKeymaps" = true;
      "oil-code.hasNerdFont" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
          "nixpkgs" = {
            "expr" = "import <nixpkgs> {}";
          };
          "options" = {
            "nixos" = {
              "expr" =
                "(builtins.head (builtins.attrValues (builtins.getFlake \"${workspaceFolder}\").nixosConfigurations)).options";
            };
            "home-manager" = {
              "expr" =
                "(builtins.head (builtins.attrValues (builtins.getFlake \"${workspaceFolder}\").homeConfigurations)).options";
            };
            "nix-darwin" = {
              "expr" =
                "(builtins.head (builtins.attrValues (builtins.getFlake \"${workspaceFolder}\").darwinConfigurations)).options";
            };
          };
        };
      };
      "vim.useSystemClipboard" = true;
      "vim.leader" = "<space>";
      "vim.insertModeKeyBindings" = [
        {
          before = [
            "j"
            "k"
          ];
          after = [ "<Esc>" ];
        }
      ];
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          before = [ "-" ];
          commands = [ "oil-code.open" ];
        }
        {
          before = [ "<CR>" ];
          commands = [ "oil-code.select" ];
        }
        {
          before = [
            "<leader>"
            "c"
          ];
          commands = [ "workbench.action.showCommands" ];
        }
        {
          before = [
            "<leader>"
            "f"
            "r"
          ];
          commands = [ "actions.find" ];
        }
        {
          before = [ "[" ];
          commands = [
            "editor.action.marker.next"
            "closeMarkersNavigation"
          ];
        }
        {
          before = [ "]" ];
          commands = [
            "editor.action.marker.prev"
            "closeMarkersNavigation"
          ];
        }
        {
          before = [
            "<leader>"
            "f"
            "w"
          ];
          commands = [ "workbench.action.findInFiles" ];
        }
        {
          before = [
            "<ctrl>"
            "d"
          ];
          commands = [ "workbench.action.terminal.kill" ];
          when = "terminalFocus";
        }
        {
          before = [
            "<ctrl>"
            "d"
          ];
          commands = [ "workbench.action.closeActiveEditor" ];
          when = "!terminalFocus";
        }
        {
          before = [
            "<leader>"
            "f"
            "f"
          ];
          commands = [ "workbench.action.quickOpen" ];
        }
        {
          before = [
            "g"
            "r"
            "r"
          ];
          commands = [ "editor.action.goToReferences" ];
        }
        {
          before = [
            "g"
            "r"
            "d"
          ];
          commands = [ "editor.action.revealDefinition" ];
        }
        {
          before = [
            "g"
            "r"
            "i"
          ];
          commands = [ "editor.action.goToImplementation" ];
        }
        {
          before = [
            "<leader>"
            "t"
            "b"
          ];
          commands = [ "gitlens.toggleLineBlame" ];
        }
        {
          before = [
            "<leader>"
            "q"
          ];
          commands = [ "sqltools.executeQuery" ];
          when = "editorLangId == sql";
        }
        {
          before = [ "K" ];
          commands = [ "editor.action.showHover" ];
        }
      ];
      "vim.visualModeKeyBindingsNonRecursive" = [
        {
          before = [
            "<leader>"
            "s"
            "w"
          ];
          commands = [ "workbench.action.findInFiles" ];
        }
      ];
      "vim.handleKeys" = {
        "<C-p>" = true;
        "<C-f>" = true;
      };
      "editor.formatOnSave" = true;
      "workbench.colorTheme" = "Tokyo Night";
    };
  };
}
