{ config, pkgs, lib, ... }:

{

  imports = [
    ./wm/xmonad
    ./wm/polybar
    ./services/dunst
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
    pkgs.xclip
    pkgs.lazygit

    pkgs.qutebrowser
    pkgs.google-chrome
    pkgs.polybar
    pkgs.trayer

    pkgs.pavucontrol # pulseaudio volume control
    pkgs.paprefs # pulseaudio preferences

    pkgs.pulsemixer

    # xmonad
    pkgs.dialog # Dialog boxes on the terminal (to show key bindings)
    pkgs.networkmanager_dmenu # networkmanager on dmenu
    pkgs.networkmanagerapplet # networkmanager applet
    pkgs.nitrogen # wallpaper manager
    pkgs.xcape # keymaps modifier
    pkgs.xorg.xkbcomp # keymaps modifier
    pkgs.xorg.xmodmap # keymaps modifier
    pkgs.xorg.xrandr # display manager (X Resize and Rotate protocol)

    # dropbox
    pkgs.maestral

    # Notifications send
    pkgs.libnotify

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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
    # EDITOR = "emacs";
  };

  programs.alacritty = import ./pkgs/alacritty/default.nix { inherit pkgs; };

  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
    extraConfigLua = lib.fileContents ./neovim/init.lua;
    plugins.treesitter = {
      enable = true;
    };

    clipboard.register = "unnamedplus";

    plugins.telescope = {
      enable = true;
      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>pf" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>b" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = "oldfiles";
        "<C-f>" = "live_grep";
      };
    };
    plugins.barbar = {
      enable = true;
    };
    plugins.lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          gD = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<F2>" = "rename";
        };
      };
      servers = {
	      tsserver.enable = true;
	      eslint.enable = true;
	      graphql.enable = true;
	      html.enable = true;
	      nixd.enable = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      theme = "robbyrussell";
      plugins = [ 
        "git" 
	      "node"
	      "history"
        "zsh-users/zsh-autosuggestions" 
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } 
      ];
    };
    autosuggestion.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    extraConfig = ''
      (setq standard-indent 2)
    '';
  };

  programs.dircolors.enableZshIntegration = true;
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:#33658A";
      format = "[ ♥ $time ]($style)";
    };
    #shell = {
    #  disabled = false;
    #  format = "$indicator";
    #  fish_indicator = "";
    #  bash_indicator = "[BASH](bright-white) ";
    #  zsh_indicator = "[ZSH](bright-white) ";
    #};
    username = {
      show_always = true;
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = " ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

  programs.git = {
    enable = true;
  };


  programs.helix = {
  enable = true;
  settings = {
    theme = "autumn_night_transparent";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
    formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
  }];
  themes = {
    autumn_night_transparent = {
      "inherits" = "autumn_night";
      "ui.background" = { };
    };
  };
  };

  #services.picom.enable = true;
  #services.picom.backend = "glx";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
