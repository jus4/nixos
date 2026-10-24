{ pkgs, ... } :

{
  programs.dircolors.enableZshIntegration = true;
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
    initContent = ''
      if [ -f "$HOME/env/codestral.env" ]; then
        source "$HOME/env/codestral.env"
      fi

      if [ -f "$HOME/env/gemini.env" ]; then
        source "$HOME/env/gemini.env"
      fi
    '';
  };
}
