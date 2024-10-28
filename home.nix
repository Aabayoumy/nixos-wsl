{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    eza
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    btop
    jq
    killall
    mosh
    procs
    ripgrep
    sd
    tree
    unzip
    wget
    aria2
    zsh-autosuggestions
    zsh-syntax-highlighting
    zip
    git
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use
    micro
    
    # key tools
    gh # for bootstrapping
    just

    # core languages
    rustup

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    nil # nix

    # formatters and linters
    alejandra # nix
    deadnix # nix
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
    ./zsh.nix
    ./tmux.nix
  ];

  home.stateVersion = "24.05";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    file = {
      ".config/starship.toml".source = ./starship.toml;
      ".config/fastfetch/config.jsonc".source = ./config.jsonc;
    };
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    starship.enableZshIntegration = true;
    # starship.settings = {
    #   aws.disabled = true;
    #   gcloud.disabled = true;
    #   kubernetes.disabled = false;
    #   git_branch.style = "242";
    #   directory.style = "blue";
    #   directory.truncate_to_repo = false;
    #   directory.truncation_length = 8;
    #   python.disabled = true;
    #   ruby.disabled = true;
    #   hostname.ssh_only = false;
    #   hostname.style = "bold green";
    # };
    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    zoxide.options = ["--cmd cd"];
    broot.enable = true;
    broot.enableZshIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "abayoumy@outlook.com"; # FIXME: set your git email
      userName = "Ahmed Bayoumy"; #FIXME: set your git username
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
        init.defaultBranch = "master";
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # # FIXME: This is my fish config - you can fiddle with it if you want
    # fish = {
    #   enable = true;
    #   # FIXME: run 'scoop install win32yank' on Windows, then add this line with your Windows username to the bottom of interactiveShellInit
    #   # fish_add_path --append /mnt/c/Users/abayoumy/AppData/Local/Microsoft/WinGet/Packages/equalsraf.win32yank_Microsoft.Winget.Source_8wekyb3d8bbwe
    #   interactiveShellInit = ''
    #     ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

    #     ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
    #         owner = "rebelot";
    #         repo = "kanagawa.nvim";
    #         rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
    #         sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
    #       }
    #       + "/extras/kanagawa.fish")}

    #     set -U fish_greeting
    #   '';
    #   functions = {
    #     refresh = "source $HOME/.config/fish/config.fish";
    #     take = ''mkdir -p -- "$1" && cd -- "$1"'';
    #     ttake = "cd $(mktemp -d)";
    #     show_path = "echo $PATH | tr ' ' '\n'";
    #     posix-source = ''
    #       for i in (cat $argv)
    #         set arr (echo $i |tr = \n)
    #         set -gx $arr[1] $arr[2]
    #       end
    #     '';
    #   };
    #   shellAbbrs =
    #     {
    #       gc = "nix-collect-garbage --delete-old";
    #     }
    #     # navigation shortcuts
    #     // {
    #       ".." = "cd ..";
    #       "..." = "cd ../../";
    #       "...." = "cd ../../../";
    #       "....." = "cd ../../../../";
    #     }
    #     # git shortcuts
    #     // {
    #       gapa = "git add --patch";
    #       grpa = "git reset --patch";
    #       gst = "git status";
    #       gdh = "git diff HEAD";
    #       gp = "git push";
    #       gph = "git push -u origin HEAD";
    #       gco = "git checkout";
    #       gcob = "git checkout -b";
    #       gcm = "git checkout master";
    #       gcd = "git checkout develop";
    #       gsp = "git stash push -m";
    #       gsa = "git stash apply stash^{/";
    #       gsl = "git stash list";
    #     };
    #   shellAliases = {
    #     jvim = "nvim";
    #     lvim = "nvim";
    #     pbcopy = "/mnt/c/Windows/System32/clip.exe";
    #     pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
    #     explorer = "/mnt/c/Windows/explorer.exe";
    #   };
    #   plugins = [
    #     {
    #       inherit (pkgs.fishPlugins.autopair) src;
    #       name = "autopair";
    #     }
    #     {
    #       inherit (pkgs.fishPlugins.done) src;
    #       name = "done";
    #     }
    #     {
    #       inherit (pkgs.fishPlugins.sponge) src;
    #       name = "sponge";
    #     }
    #   ];
    # };
  };
}
