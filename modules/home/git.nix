{ pkgs, username, ... }:
{
  home.packages = [ pkgs.gh ]; 

  programs.git = {
    enable = true;

    userName = "Megakuul";
    userEmail = "linus.moser@megakuul.ch";

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      core.excludesFile = "/home/${username}/.config/git/.gitignore";
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = false;
        diff-so-fancy = true;
        navigate = true;
      };
    };
  };


  xdg.configFile."git/.gitignore".text = ''
    .vscode
  '';
}
