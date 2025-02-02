{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  # config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    lunarvim
    mosh
    neovim
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use

    # key tools
    gh # for bootstrapping
    just

    # core languages
    rustup
    go
    lua
    nodejs
    python3
    typescript

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    ccls # c / c++
    gopls
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix
    nodePackages.pyright

    # formatters and linters
    alejandra # nix
    black # python
    ruff # python
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
    yamllint

    # misc
    deterministic-uname
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "23.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "lvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [ 
      pkgs.fishPlugins.sponge
      pkgs.fishPlugins.pure
      pkgs.fishPlugins.puffer
      pkgs.fishPlugins.plugin-git
      pkgs.fishPlugins.fzf-fish
      pkgs.fishPlugins.forgit
      pkgs.fishPlugins.colored-man-pages
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  # FIXME: if you want to version your LunarVim config, add it to the root of this repo and uncomment the next line
  # https://github.com/bonsairobo/MyNixOs/blob/f3fff2969131350966c8c2def7283829c98ddbdd/configuration.nix#L234-L243
  home.file.".config/lvim/config.lua".source = ./lvim_config.lua;
  home.file.".config/lvim/lua/user/markdown_syn.lua".source = ./markdown_syn.lua;
  home.file.".config/lvim/lua/user/noice.lua".source = ./noice.lua;
  home.file.".config/lvim/lua/user/presence.lua".source = ./presence.lua;
  home.file.".config/lvim/lua/user/sidebar.lua".source = ./sidebar.lua;

  home.file.".gitignore".source = ./gitignore;

  #home.file = {
  #  lunarvim_conf = { source = ./config.lua; target = ".config/lvim/config.lua"; };
  #  lunarvim_markdown_syn = { source = ./markdown_syn.lua; target = ".config/lua/user/markdown_syn.lua"; };
  #  lunarvim_noice = { source = ./noice.lua; target = ".config/lua/user/noice.lua"; };
  #  lunarvim_presence = { source = ./presence.lua; target = ".config/lua/user/presence.lua"; };
  #  lunarvim_sidebar = { source = ./sidebar.lua; target = ".config/lua/user/sidebar.lua"; };
  #};

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    starship.enableTransience = true;
    starship.settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    broot.enable = true;

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
      userEmail = ""; # FIXME: set your git email
      userName = "RelativeSure"; #FIXME: set your git username
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
        core = {
          editor = "lvim";
          excludesFile = "~/.gitignore";
        };
        fetch = {
          prune = true;
        };
        alias = {
          empty = "git commit --allow-empty";
          delete-local-merged = "!git fetch && git branch --merged | egrep -v 'master' | xargs git branch -d";
        };
        init = {
          defaultBranch = "master";
        };
        color = {
          ui = true;
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        set -gx GPG_TTY (tty)
        fish_add_path $HOME/.local/bin
        function starship_transient_prompt_func
          starship module character
        end
        function starship_transient_rprompt_func
          starship module time
        end
      '';
      #plugins = [
      #  { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      #  { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      #  { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
      #  { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      #  { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      #  { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      #  { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      #];
    };
  };
}
