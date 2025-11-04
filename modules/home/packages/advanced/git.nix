{ pkgs, username, ... }:
{
  home.packages = [ pkgs.gh ]; 

  programs.git = {
    enable = true;

    settings = {
      user.name = "Megakuul";
      user.email = "linus.moser@megakuul.ch";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      core.excludesFile = "/home/${username}/.config/git/.gitignore";
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };

  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = false;
      diff-so-fancy = true;
      navigate = true;
    };
  };

  xdg.configFile."git/.gitignore".text = ''
    .vscode
  '';
}
