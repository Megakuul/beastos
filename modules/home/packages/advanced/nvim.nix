{pkgs, ...}: {
  home.packages = (
    with pkgs; [
      neovim
      wl-clipboard
      fd
      ripgrep
    ]
  );

  xdg.configFile.nvim.source = ../../../../config/nvim;
}
