{
  osConfig,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "${osConfig.beast.profile.git.username}";
      user.email = "${osConfig.beast.profile.git.email}";
      user.signingkey = "${osConfig.beast.profile.git.configPath}/signingkey";
      gpg.format = "ssh";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = true;
      core.excludesFile = "${osConfig.beast.profile.git.configPath}/.gitignore";
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git@codeberg.org:" = {
          insteadOf = "https://codeberg.org/";
        };
      };
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "${osConfig.beast.profile.git.configPath}/github";
        identitiesOnly = true;
      };
      "codeberg.org" = {
        hostname = "codeberg.org";
        identityFile = "${osConfig.beast.profile.git.configPath}/codeberg";
        identitiesOnly = true;
      };
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
