{
  osConfig,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    settings = {
      user.name = "${osConfig.beast.profile.git.username}";
      user.email = "${osConfig.beast.profile.git.email}";
      user.signingkey = "/home/${osConfig.beast.profile.username}/.config/git/signingkey";
      gpg.format = "ssh";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      core.excludesFile = "/home/${osConfig.beast.profile.username}/.config/git/.gitignore";
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
