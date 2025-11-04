{...}: {
  programs.zsh = {
    shellAliases = {
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      nano = "nvim";
      code = "codium";
      diff = "delta --diff-so-fancy --side-by-side";
      less = "bat";
      img = "kitten icat";
      pdf = "tdf";
      open = "xdg-open";
      man = "BAT_THEME='default' batman";

      ls = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      ns = "nom-shell --run zsh";
      nd = "nom develop --command zsh";
      nb = "nom build";
    };
  };
}
