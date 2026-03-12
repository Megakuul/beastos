{ ... }:
{
  services.kiwi-shell = {
    enable = true;
    settings = {
      primary_color = "rgb(226, 221, 235)";
      theme = "glass";
      bar_margin = 5;
      dock_margin = 5;
      dock_home = true;
      dock_trash = true;
    };
  };
}
