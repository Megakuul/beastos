{ ... }:
{
  services.kiwi-shell = {
    enable = true;
    settings = {
      primary_color = "rgb(200, 100, 50)";
      theme = "glass";
      bar_margin = 7;
      dock_margin = 7;
      dock_home = true;
      dock_trash = true;
    };
  };
}
