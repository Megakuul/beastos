{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    settings = {
      user.name = "${config.beast.profile.git.username}";
      user.email = "${config.beast.profile.git.email}";
      user.signingkey = "/home/${config.beast.profile.username}/.config/git/signingkey";
      gpg.format = "ssh";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      core.excludesFile = "/home/${config.beast.profile.username}/.config/git/.gitignore";
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
