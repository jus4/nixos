#xorg.xbacklight Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{  config, inputs, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./strongswan/strongswan.nix
    ];


  # Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "juice"; # Define your hostname.
  networking.useNetworkd = true;
  environment.etc."ppp/options".text = "ipcp-accept-remote";
  
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
    driSupport = true;
    driSupport32Bit = true;
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

  sound.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Configure console keymap
  console.keyMap = "fi";
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juice = {
    isNormalUser = true;
    description = "Juice";
    extraGroups = [ "networkmanager" "wheel" "video" "storage" "camera" "docker"];
    packages = with pkgs; [ ];
  };

  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;

  boot.extraModprobeConfig = ''
      options hid_apple fnmode=2
  '';
  boot.kernelModules = [ "hid-apple"  ];
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap,avrcp"
  ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  programs = {
    zsh = {
      enable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = [ "juice" ];

  #light
  programs.light.enable = true;

  #slock
  programs.slock.enable = true;
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";

  boot.kernelParams = [ "button.lid_init_state=open" ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  fonts.packages = with pkgs; [ nerdfonts ];
  environment.systemPackages = with pkgs; [
    zlib
    acpi
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nerdfonts
    pciutils
    glxinfo
    dunst
    picom
    pcre.dev
    node2nix
    zsh
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
    ruby
    neofetch
    alacritty
    alacritty-theme
    firefox
    lutris
    brave
    dmenu
    pciutils
    rofi
    wget
    lshw
    strongswan
    sops
    age
  ];

  # NixLd 
  programs.nix-ld.enable = true;

  networking.resolvconf.enable = false;

  services = {

    # Open SSH
    # openssh.enable = true;

    # strongswan = {
    #   enable = true;
    #   secrets = [ "/etc/ipsec.d/ipsec.secrets" ];
    #   setup = {
    #     strictcrlpolicy = "yes";
    #     uniqueids = "yes";
    #   };
    #
    #   connections.crasman = {
    #     # Connection Basics
    #     auto = "add";  # Changed from "add" for automatic connection
    #     type = "tunnel";
    #     keyexchange = "ikev1";
    #
    #     left = "%any";
    #     leftauth = "psk";
    #     leftauth2 = "xauth";
    #     leftsourceip = "%config";
    #     leftid = "vpnuser@local";
    #
    #     # Remote (Server) Settings
    #     right = "vpn1.crasman.fi";
    #     rightid = "79.134.111.186";
    #     rightsubnet = "0.0.0.0/0";
    #     rightauth = "psk";
    #
    #     # XAuth Configuration
    #     # xauth_identity =  "jussi.leskinen@crasman.fi";
    #     # xauth_identity =  "jussi.leskinen@crasman.fi";
    #     xauth_identity = /run/secrets/strongswan_xauth_identity;
    #
    #     # Security Parameters
    #     ike = "aes256-sha256-modp1536";  # Changed from sha512 (more compatible)
    #     esp = "aes256-sha256-modp1536";
    #     rekey = "yes";
    #     reauth = "yes";
    #
    #     # NAT/DPD Settings
    #     forceencaps = "yes";  # Critical for NAT traversal
    #     fragmentation = "yes";
    #     dpdaction = "restart";
    #     dpddelay = "10s";
    #     dpdtimeout = "60s";
    #
    #     # Timeouts
    #     ikelifetime = "14400s";
    #     lifetime = "3600s";
    #   };
    #
    # };

    printing = {
      drivers = [ pkgs.hplip ];
      enable = true;
    };

    gnome.gnome-keyring.enable = true;
    upower = { 
      enable = true;
      criticalPowerAction = "Hibernate";
      usePercentageForPolicy = true;
      percentageAction = 80;
      percentageLow = 80;
      percentageCritical = 77;
    };

    resolved = {
      enable = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    # Configure keymap in X11
    xserver = {
      enable = true;
      layout = "fi";
      imwheel.enable = true;
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      xkbVariant = "";

      videoDrivers = ["nvidia"];

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
    suspend-on-low-battery = {
      description = "Suspend on low battery";
      serviceConfig = {
        ExecStart = "./suspend_on_low.sh";
      };
    };
  };

  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1min";
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # powerManagement.enable = false; // did cause sleep/suspend to fail ?
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = pkgs.nvidiaPackages.stable; 
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = { 
      offload.enable = true;
		# Make sure to use the correct Bus ID values for your system!
    	intelBusId = "PCI:00:02:0";
		  nvidiaBusId = "PCI:03:00:0";

		#  intelBusId = "PCI:00:02.0";
		#  nvidiaBusId = "PCI:01:00.0";
	  };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.firewall.allowedUDPPorts = [ 500 4500 ];
}
