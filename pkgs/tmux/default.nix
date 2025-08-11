{ pkgs, ... }:

{
  programs.tmux = {
    # Tmux
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    # enableVim = true;
    # tmuxPlugins.powerline.enable = true;
    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.power-theme
        tmuxPlugins.prefix-highlight
        tmuxPlugins.sensible
        tmuxPlugins.yank
      ];
    extraConfig = ''
      set -g @plugin 'erikw/tmux-powerline'
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      set-option -g status-position top 
      unbind C-s
      set -g prefix C-s
      bind C-s send-prefix
    '';
  };
}


