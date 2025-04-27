#xorg.xbacklight Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


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
  environment.etc."ppp/options".text = "ipcp-accept-remote";
  
  networking.extraHosts =
  ''
    127.0.0.1 vcap.me
    127.0.0.1 gate.vcap.me
    127.0.0.1 stage.vcap.me
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # networking.networkmanager.insertNameservers = [
  #   "10.1.0.1"  # Primary DNS
  #   "10.1.0.6"  # Primary DNS
  # ];

  # networking = {
  #   nameservers = [
  #   ];
  # };

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

  # Lates kernel
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

  ];

  # Testing node node_modules
  programs.nix-ld.enable = true;

  services = {
    printing.enable = true;

    gnome.gnome-keyring.enable = true;
    upower = { 
      enable = true;
      criticalPowerAction = "Hibernate";
      usePercentageForPolicy = true;
      percentageAction = 80;
      percentageLow = 80;
      percentageCritical = 77;
    };

    resolved.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    emacs = {
      enable = true;
      package = pkgs.emacs;
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

  systemd.services.upower.enable = true;

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
    # open = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

}
