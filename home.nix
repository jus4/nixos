{ pkgs, ... }:

{
  imports = [
    # ./wm/xmonad
    ./wm/polybar
    ./services/dunst
    ./pkgs/tmux
    ./pkgs/nixvim
    ./pkgs/starship
    ./pkgs/alacritty
    ./pkgs/emacs
    ./pkgs/newsboat
    ./pkgs/zsh
    ./modules/suckless.nix
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

  xdg.configFile."picom/picom.conf".source = ./pkgs/picom/picom.conf;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Development tools
    # ollama

    xwallpaper
    zip
    unzip
    xclip
    lazygit
    mkcert
    tmux
    calc
    feh

    #Database
    mysql84
    # zlib
    zstd   # ← required for mysql2 to link
    figma-linux

    xorg.xev
    input-remapper
    evtest

    lm_sensors

    gh

    nix-tree

    qutebrowser
    # ladybird
    google-chrome
    polybar
    trayer

    pavucontrol # pulseaudio volume control
    paprefs # pulseaudio preferences

    # xbindkeys
    # xbindkeys-config
    xdotool

    roslyn-ls
    roslyn
    dotnet-sdk

    pulsemixer

    appimage-run

    #browser
    links2
    lynx

    #Free with no ads
    freetube

    #share files to phone
    localsend

    # Time tracking
    timewarrior

    # pkgs.teams

    gphoto2
    libgphoto2

    # Gaming
    lutris
    heroic
    wine
    steam

    #postman
    postman

    #office 
    libreoffice

    #file browsing
    xfce.thunar

    # Grep for search
    ripgrep

    # xmonad
    dialog # Dialog boxes on the terminal (to show key bindings)
    networkmanager_dmenu # networkmanager on dmenu
    networkmanagerapplet # networkmanager applet
    nitrogen # wallpaper manager
    xcape # keymaps modifier
    xorg.xkbcomp # keymaps modifier
    xorg.xmodmap # keymaps modifier
    xorg.xrandr # display manager (X Resize and Rotate protocol)

    # network
    networkmanagerapplet
    whois
    dig

    # dropbox
    maestral

    # Notifications send
    libnotify

    # Communication
    discord
    # whatsapp-for-linux

    #music
    spotify

    #screenshot
    flameshot

    #pdf
    kdePackages.okular

    # camera
    gphoto2fs
    gphoto2

    #video
    mpv
    vlc
    shotcut

    #torrent
    deluged

    #ebooks
    calibre

    #LLM
    opencode  

    # Tailwindcss cli 
    tailwindcss
    figma-linux
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
    nerd-fonts.jetbrains-mono
    font-awesome
    material-design-icons

    # spell checking
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science


    #DWM blocks
    (pkgs.dwmblocks.overrideAttrs (old: {
      src = ./pkgs/dwmblocks;
    }))

    # Custom scripts
    (pkgs.writeShellScriptBin "cpu_usage" ''
      #!/bin/sh
      usage=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
      echo "$usage"
    '')

    (pkgs.writeShellScriptBin "net_status" ''
      #!/bin/sh
      line=$(nmcli -t -f TYPE,NAME,DEVICE connection show --active 2>/dev/null \
        | grep -E '^(802-11-wireless|802-3-ethernet):' | head -n1)
      if [ -z "$line" ]; then
        echo "󰤭 Disconnected"
        exit 0
      fi
      type=''${line%%:*}
      rest=''${line#*:}
      name=''${rest%%:*}
      dev=''${rest#*:}
      ip=$(nmcli -t -f IP4.ADDRESS dev show "$dev" 2>/dev/null \
        | head -n1 | sed 's|.*:||; s|/.*||')
      if [ -z "$ip" ]; then
        echo "󰤭 Disconnected"
        exit 0
      fi
      if [ "$type" = "802-11-wireless" ]; then
        echo "󰤨 $name $ip"
      else
        echo "󰈀 $dev $ip"
      fi
    '')

    (pkgs.writeShellScriptBin "battery" ''
      #!/bin/sh
      cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
      status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
      case "$status" in
        Charging)    icon="" ;;
        Discharging) icon="" ;;
        Full)        icon="" ;;
        *)           icon="" ;;
      esac
      echo "$icon $cap%"
    '')
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
    # ASPELL_CONF = "dict-dir /home/juice/.nix-profile/lib/aspell";
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
