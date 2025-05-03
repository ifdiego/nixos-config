{ config, pkgs, ... }:

{
  home.username = "diego";
  home.homeDirectory = "/home/diego";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    btop
    cargo
    clang
    cloc
    curl
    delve
    docker
    docker-compose
    duf
    fastfetch
    fd
    ffmpeg-full
    gh
    glow
    go
    go-task
    gopls
    goreleaser
    hyperfine
    jq
    lldb
    nil
    nodejs_22
    python3Full
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    tree
    wget
    xclip
    zellij
    zig
    zls
  ];

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
    shellAbbrs = {
      g = "git";
      n = "nvim";
      temp = "pushd (mktemp -d)";
      ta = "tmux new -A -s 0";
      ks = "tmux kill-server";
      nrs = "sudo nixos-rebuild switch";
    };
    interactiveShellInit = ''
      set fish_greeting
      fish_config prompt choose arrow
      fish_add_path (go env GOPATH)/bin
      fish_add_path ~/.cargo/bin
    '';
  };

  programs.fzf = {
    enable = true;
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      font-feature = "-calt, -liga, -dlig";
      mouse-hide-while-typing = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Diego Alves";
    userEmail = "ifdiego@users.noreply.github.com";
    aliases = {
      br = "branch";
      ci = "commit";
      co = "checkout";
      dc = "diff --cached";
      ec = "config --global -e";
      lg = "log --oneline --graph";
      st = "status";
    };
    extraConfig = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
      core.editor = "nvim";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      fzf-lua
      (nvim-treesitter.withPlugins (p: [
        p.go
        p.rust
        p.typescript
        p.zig
      ]))
      blink-cmp
      friendly-snippets
      neogit
      plenary-nvim
      conform-nvim
      mini-nvim
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = [ "~/.ssh/id_ed25519" ];
        identitiesOnly = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    historyLimit = 100000;
    mouse = true;
    customPaneNavigationAndResize = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g focus-events on
    '';
  };

  programs.zoxide = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  programs.home-manager.enable = true;
}
