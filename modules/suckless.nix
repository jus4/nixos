{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../pkgs/dmenu;
      patches = [ ];
    }))
    slock
    surf
  ];
}
