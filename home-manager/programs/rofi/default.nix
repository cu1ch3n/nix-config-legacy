{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = ./nord.rasi;
    extraConfig = {
      modi = "drun,window,filebrowser";
      show-icons = false;
      dpi = 180;
    };
  };
}
