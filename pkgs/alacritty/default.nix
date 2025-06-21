{ pkgs, ... }:

{
  enable = true;

  settings = {
    window = {
      title = "Terminal";
      opacity = 0.65;

      position = {
        x = 900;
        y = 350;
      };
      dimensions = {
        lines = 40;
        columns = 125;
      };
    };

    font = {
      size = 12;
    };
    env.TERM = "xterm-256color";

    shell = {
      program = "/run/current-system/sw/bin/zsh";
    };

    colors = {
      primary = {
        background = "0x000000";
        foreground = "0xEBEBEB";
      };
      cursor = {
        text   = "0x000000";
        cursor = "0xFF261E";
      };
      normal = {
        black   = "0x0D0D0D";
        red     = "0xFF301B";
        green   = "0xA0E521";
        yellow  = "0xFFC620";
        blue    = "0x1BA6FA";
        magenta = "0x8763B8";
        cyan    = "0x21DEEF";
        white   = "0xEBEBEB";
      };
      bright = {
        black   = "0x6D7070";
        red     = "0xFF4352";
        green   = "0xB8E466";
        yellow  = "0xFFD750";
        blue    = "0x1BA6FA";
        magenta = "0xA578EA";
        cyan    = "0x73FBF1";
        white   = "0xFEFEF8";
      };
    };
  };
}
