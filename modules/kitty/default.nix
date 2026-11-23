{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
    };
    extraConfig = ''
      # Raw kitty.conf lines go here
    '';
  };
}
