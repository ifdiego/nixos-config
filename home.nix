{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "diego";
  home.homeDirectory = "/home/diego";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    btop
    cargo
    clang
    fastfetch
    fd
    fish
    fzf
    gh
    ghostty
    git
    go
    gopls
    helix
    lazygit
    nodejs
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    starship
    zellij
    zig
    zls
    zoxide
  ];

  programs.fish = {
    enable = true;
    shellAbbrs = {
      temp = "pushd (mktemp -d)";
      nrs = "sudo nixos-rebuild switch";
      lg = "lazygit";
      zj = "zellij";
    };
    interactiveShellInit = ''
      set fish_greeting
      fish_add_path (go env GOPATH)/bin
      fish_add_path ~/.cargo/bin
    '';
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "GitHub-Dark-Default";
      cursor-invert-fg-bg = true;
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
      authors = "!git log --format='%an <%ae>' | sort -u";
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

  programs.helix = {
    enable = true;
    settings = {
      theme = "github_dark";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
      };
    };
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

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        indent_style = "space";
        indent_size = 4;
      };
      "*.{lua,yml,nix}" = {
        indent_size = 2;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
