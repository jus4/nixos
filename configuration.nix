#xorg.xbacklight Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{  config, inputs, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];


  # Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "juice"; # Define your hostname.
  # networking.useNetworkd = true;
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  # Hibernation
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32GB in MB
    }
  ];

  boot.kernelParams = ["resume_offset=201213952" "usbcore.autosuspend=-1" "amdgpu.noretry=0" "amdgpu.runpm=0" "amdgpu.sg_display=0"];
  boot.resumeDevice = "/dev/disk/by-uuid/135cda41-5466-4565-b28e-57eeb4b857cd";
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  networking.extraHosts =
  ''
    127.0.0.1 vcap.me
    127.0.0.1 gate.vcap.me
    127.0.0.1 stage.vcap.me
  '';

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # enableStrongSwan = true;
  };


  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.enableAllFirmware = true;
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    driSupport32Bit = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [
    #   amdvlk       # AMD's Vulkan driver
    #   # optionally, packages for VA-API / VDPAU etc if you need video decode/encode
    # ];
    # extraPackages32 = with pkgs; [
    #   driversi686Linux.amdvlk
    # ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };
 

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; security.rtkit.enable = true; services.pipewire = {
    enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Prefer HDMI/DP (monitor) audio when connected; fall back to laptop speakers.
  services.pipewire.wireplumber.extraConfig."51-hdmi-default" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.*hdmi.*"; } ];
        actions.update-props."priority.session" = 1400;
      }
    ];
  };

  # sound.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Configure console keymap
  console.keyMap = "fi";
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juice = {
    isNormalUser = true;
    description = "Juice";
    extraGroups = [ "networkmanager" "wheel" "video" "storage" "camera" "docker" "adbusers" "plugdev"];
    packages = with pkgs; [ ];
  };

  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;

  boot.extraModprobeConfig = ''
      options hid_apple fnmode=2
  '';
  boot.kernelModules = [ "hid-apple" "amdgpu" ];
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap,avrcp"
  ];



  # Latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_6_12;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.extraModulePackages = [ config.hardware.nvidia.package ];

  programs = {
    zsh = {
      enable = true;
    };
  };


  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman # Handles automatic mounting of camera backends
    ];
  };

  # 3. Register the gphoto2 program and its hardware udev hardware rules 
  programs.gphoto2.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = [ "juice" ];

  #light
  # programs.light.enable = true;

  #slock
  programs.slock.enable = true;
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";
  # boot.kernelParams = [ "button.lid_init_state=open" "nvidia.env.preserve_video_memory_allocations=1" ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # fonts.packages = with pkgs; [ nerdfonts ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts._3270
    nerd-fonts.symbols-only 
  ];
  environment.systemPackages = with pkgs; [
    usbutils
    zlib
    acpi
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts._3270
    nerd-fonts.symbols-only 
    brightnessctl
    # glxinfo
    (pkgs.writeShellScriptBin "volume" ''
      #!/bin/sh
      set -eu
      WPCTL="${pkgs.wireplumber}/bin/wpctl"
      DUNSTIFY="${pkgs.dunst}/bin/dunstify"
      AWK="${pkgs.gawk}/bin/awk"

      case "''${1:-}" in
        up)   "$WPCTL" set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ ;;
        down) "$WPCTL" set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
        mute) "$WPCTL" set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *) echo "usage: volume up|down|mute" >&2; exit 2 ;;
      esac

      info=$("$WPCTL" get-volume @DEFAULT_AUDIO_SINK@)
      pct=$("$AWK" -v s="$info" 'BEGIN{ split(s,a," "); printf "%d", a[2]*100 }')
      case "$info" in
        *MUTED*) icon=audio-volume-muted; text="Muted" ;;
        *) if   [ "$pct" -lt 34 ]; then icon=audio-volume-low
           elif [ "$pct" -lt 67 ]; then icon=audio-volume-medium
           else icon=audio-volume-high; fi
           text="Volume ''${pct}%" ;;
      esac
      "$DUNSTIFY" -a volume -i "$icon" -h int:value:"$pct" -r 2593 -t 1500 "$text"
    '')
    (pkgs.writeShellScriptBin "brightness" ''
      #!/bin/sh
      set -eu
      BCTL="${pkgs.brightnessctl}/bin/brightnessctl"
      DUNSTIFY="${pkgs.dunst}/bin/dunstify"
      AWK="${pkgs.gawk}/bin/awk"

      case "''${1:-}" in
        up)   "$BCTL" set 5%+ ;;
        down) "$BCTL" set 5%- ;;
        *) echo "usage: brightness up|down" >&2; exit 2 ;;
      esac

      pct=$("$BCTL" -m | "$AWK" -F, '{gsub(/%/,"",$4); print $4}')
      if   [ "$pct" -lt 34 ]; then icon=display-brightness-low
      elif [ "$pct" -lt 67 ]; then icon=display-brightness-medium
      else icon=display-brightness-high; fi
      "$DUNSTIFY" -a brightness -i "$icon" -h int:value:"$pct" -r 2594 -t 1500 "Brightness ''${pct}%"
    '')
    picom
    pcre.dev
    # node2nix
    helix
    typescript
    findutils
    starship
    slack
    slock
    xorg.xrandr
    arandr
    xorg.xbacklight
    git
    go
    openfortivpn
    openconnect
    openssl
    nodejs
    pnpm
    bun
    ruby
    # neofetch
    alacritty-theme
    firefox
    lutris
    vulkan-tools
    brave
    pciutils
    rofi
    wget
    lshw
    strongswan
    sops
    age

    #db 
    mariadb

  ];

  # NixLd 
  programs.nix-ld.enable = true;

  networking.resolvconf.enable = false;

  services = {
    tlp = {
      enable = true;
      settings = {
        # Fixes the USB-C/DisplayPort disconnects on wake
        USB_AUTOSUSPEND = 0; 
        
        # ThinkPad-specific battery health constraints (Prevents degradation)
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        
        # Balanced scaling limits for Zen 2 on AC vs Battery
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      };
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;    # AMD
    };

    printing = {
      drivers = [ pkgs.hplip ];
      enable = true;
    };

    gnome.gnome-keyring.enable = true;
    upower = { 
      enable = true;
      criticalPowerAction = "HybridSleep";
      usePercentageForPolicy = true;
      percentageLow = 15;
      percentageCritical = 10; 
      percentageAction = 8;       
    };

    # power-profiles-daemon.enable = true;

    resolved = {
      enable = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    displayManager.ly.enable = true;
    # Configure keymap in X11
    picom = {
      enable = true;
    };

    xserver = {
      enable = true;
      layout = "fi";
      imwheel.enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      displayManager.sessionCommands = ''
        xwallpaper --zoom ~/.dotfiles/walls/clouds_above_a_mountain.png
      '';
      # displayManager.lightdm.enable = true;

      windowManager = {
        #xmonad
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = builtins.readFile ./wm/xmonad/xmonad.hs;
          extraPackages = hp: [
            hp.dbus
            hp.monad-logger
          ];
        };

        #dwm
        dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs {
              src = ./pkgs/dwm;
          };
          extraSessionCommands = ''
            setsid dwmblocks >/dev/null 2>&1 &
          '';
        };
      };
      xkbVariant = "";

      videoDrivers = ["amdgpu"];

      libinput = {
        enable = true;
        touchpad.middleEmulation = true;
        touchpad.naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    blueman.enable = true;
    hardware.bolt.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  # hardware.printers.ensurePrinters = true;
  hardware.sane.enable = true;

  hardware.bluetooth = {
    package = pkgs.bluez;
    enable = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = "true";
    # fastConnectable = true;
    settings.General = {
      Name = "Juice-thinkpad-p14s";
      Enable = "Source,Sink,Media,Socket";
      Experimental = "true";
      ReconnectAttempts = 7;
      FastConnectable = "true";
      ReconnectIntervals = 5000;
      # KernelExperimental = "true";
      JustWorksRepairing = "always";
      MultiProfile = "multiple";
    };
  };

  # TODO fix not working yeat
  systemd.services = {
    upower.enable = true;
  };

  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1min";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true; # Deduplicates identical store files via hardlinks
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d";
    };
  };
  networking.firewall.allowedUDPPorts = [ 500 4500 ];
}
