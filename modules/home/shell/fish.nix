{pkgs, ...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAbbrs = {
      k = "kubectl";
    };
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
