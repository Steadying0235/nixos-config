{ config, ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    theme = "Black Metal";
    extraConfig = 
    '' 
    confirm_os_window_close 0
    background_opacity 0.7
    dynamic_background_opacity yes
    '';
  };

}
