{ pkgs, ... }:
{
  home.packages = (
    with pkgs; [ neovim wl-clipboard ]
  );

  xdg.configFile.nvim.source = ../../../../config/nvim;
}
