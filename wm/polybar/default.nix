{ config, lib, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    config = ./config.ini;
    script = ''
    '';
  };
}
