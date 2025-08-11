{ pkgs, lib, ... }:

{
  imports = [
    ./wm/xmonad
    ./wm/polybar
    ./services/dunst
    ./pkgs/tmux
    ./pkgs/nixvim
    ./pkgs/starship
    ./pkgs/alacritty
    ./pkgs/emacs
    ./pkgs/zsh
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "juice";
  home.homeDirectory = "/home/juice";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.zip
    pkgs.unzip
    pkgs.xclip
    pkgs.lazygit
    pkgs.mkcert
    pkgs.tmux
    pkgs.calc

    pkgs.xorg.xev
    pkgs.input-remapper
    pkgs.evtest

    pkgs.lm_sensors

    pkgs.nix-tree

    pkgs.qutebrowser
    # pkgs.ladybird
    pkgs.google-chrome
    pkgs.polybar
    pkgs.trayer

    pkgs.pavucontrol # pulseaudio volume control
    pkgs.paprefs # pulseaudio preferences

    pkgs.xbindkeys
    pkgs.xbindkeys-config
    pkgs.xdotool


    pkgs.pulsemixer

    pkgs.appimage-run

    #browser
    pkgs.links2
    pkgs.lynx

    #Free with no ads
    pkgs.freetube

    #share files to phone
    pkgs.localsend

    # Time tracking
    pkgs.timewarrior

    # pkgs.teams

    # Gaming
    pkgs.lutris
    pkgs.heroic
    pkgs.steam

    #postman
    pkgs.postman

    #office 
    pkgs.libreoffice

    #file browsing
    pkgs.xfce.thunar

    # Grep for search
    pkgs.ripgrep

    # xmonad
    pkgs.dialog # Dialog boxes on the terminal (to show key bindings)
    pkgs.networkmanager_dmenu # networkmanager on dmenu
    pkgs.networkmanagerapplet # networkmanager applet
    pkgs.nitrogen # wallpaper manager
    pkgs.xcape # keymaps modifier
    pkgs.xorg.xkbcomp # keymaps modifier
    pkgs.xorg.xmodmap # keymaps modifier
    pkgs.xorg.xrandr # display manager (X Resize and Rotate protocol)

    # network
    pkgs.networkmanagerapplet
    pkgs.whois
    pkgs.dig

    # dropbox
    pkgs.maestral

    # Notifications send
    pkgs.libnotify

    # Communication
    pkgs.discord
    pkgs.whatsapp-for-linux

    #music
    pkgs.spotify

    #screenshot
    pkgs.flameshot

    #pdf
    pkgs.kdePackages.okular

    # camera
    pkgs.gphoto2fs
    pkgs.gphoto2

    #video
    pkgs.mpv
    pkgs.vlc
    pkgs.shotcut

    #torrent
    pkgs.deluged

    # Golang extra
    # pkgs.air
    # pkgs.templ

    # Tailwindcss cli 
    pkgs.tailwindcss

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nerdfonts
    pkgs.font-awesome
    pkgs.material-design-icons

    # spell checking
    pkgs.aspell
    pkgs.aspellDicts.en
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   # ".config/powerline/themes/tmux/default.json".source = ./tmux/powerline-tmux-theme.json;
  #   ".config/powerline/themes/tmux/default.json" = {
  #   source = ./tmux/powerline-tmux-theme.json;  # Relative to your config dir
  #   force = true;  # Overwrite existing files if needed
  # };
  #   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  #   # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  #   # # symlink to the Nix store copy.
  #   # ".screenrc".source = dotfiles/screenrc;
  #
  #   # # You can also set the file content immediately.
  #   # ".gradle/gradle.properties".text = ''
  #   #   org.gradle.console=verbose
  #   #   org.gradle.daemon.idletimeout=3600000
  #   # '';
  # };
  # home.file.".config/powerline/themes/tmux/default.json" = {
  #   source = ./tmux/powerline-tmux-theme.json;  # Relative to ~/.dotfiles/
  #   force = true;
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/juice/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };

  programs.git = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
