{...}: {
  programs.cava = {
    enable = true;

    settings = {
      general = {
        autosens = 1;
        overshoot = 0;
      };

      color = {
        gradient = 1;
        gradient_count = 8;

        gradient_color_1 = "'#4F4675'";
        gradient_color_2 = "'#5C4E94'";
        gradient_color_3 = "'#7159c1'";
        gradient_color_4 = "'#8a4efc'";
        gradient_color_5 = "'#9763F7'";
        gradient_color_6 = "'#bd93f9'";
        gradient_color_7 = "'#C9A3FF'";
        gradient_color_8 = "'#D3B6FC'";
      };
    };
  };
}
