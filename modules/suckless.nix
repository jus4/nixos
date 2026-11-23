{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../modules/dmenu;
      patches = [];
    }))
    st
  ];
}
