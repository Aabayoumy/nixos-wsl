{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # prezto.tmux.autoStartRemote = true;
    shellAliases = lib.mkForce {
      ls = "eza --header --icons --classify";
      ll = "eza --icons -l -T -L=1";
      la = "eza --icons -la -T -L=1";
      cat = "bat";
      htop = "btop";
      top = "btop";
      fd = "fd -Lu";
      weather = "curl v2.wttr.in";
      gcap = "git add . && git commit -m";
      gp = "git push";
    };
    oh-my-zsh = {
      # 2023-07-28: oh-my-zsh doesn't have a plugin that shows me the exit code if it was not 0 (I'd probably have to define my own prompt)
      enable = true;
      # theme = "afowler";
      plugins = [
        # List of plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
        # "git" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git -> overwrites with my own "ga" alias
        "fzf" # fuzzy auto-completion and key bindings https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
        "python" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
        # conflicts with thefuck binding: "sudo" # Easily prefix your current or previous commands with sudo by pressing esc twice. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
        "systemd" # useful aliases for systemd. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
        "thefuck" # corrects your previous console command. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/thefuck
        # "tmux" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux
        "z" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z
      ];
    };
    history = {
      share = true; # false -> every terminal has it's own history
      size = 9999999; # Number of history lines to keep.
      save = 9999999; # Number of history lines to save.
      ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
      extended = true; # Save timestamp into the history file.
    };
    initExtra = ''
      ( [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ "$(ps -o comm= -p "$PPID")" = "sshd" ] ) &&
      [ $(\tmux ls | grep -w "$(whoami)" | grep -cw attached) -eq 0 ] &&
      $( $(systemd-run --scope --user echo 2>/dev/null) && echo -n systemd-run --scope --user) \tmux new -A -s "$(whoami)" && exit
      clear
      fastfetch
    '';
  };

  programs.fastfetch.enable = true;
}
