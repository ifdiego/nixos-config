{ config, pkgs, ... }:

{
  home.username = "diego";
  home.homeDirectory = "/home/diego";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bat
    btop
    cargo
    clang
    curl
    delve
    docker
    docker-compose
    duf
    eza
    fastfetch
    fd
    ffmpeg-full
    fzf
    gh
    glow
    gnumake
    go
    go-task
    gopls
    goreleaser
    gtypist
    helix
    hugo
    hyperfine
    jq
    jujutsu
    kanata
    lazygit
    lldb
    nil
    nodejs_22
    nushell
    python3Full
    rio
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    scc
    tree
    wget
    xclip
    yazi
    zed-editor
    zellij
    zig
    zls
  ];

  programs.fish = {
    enable = true;
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
      fish_config prompt choose astronaut
      fish_add_path (go env GOPATH)/bin
      fish_add_path ~/.cargo/bin
    '';
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      font-feature = "-calt, -liga, -dlig";
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      fzf-lua
      (nvim-treesitter.withPlugins (p: [
        p.go
        p.nix
        p.rust
        p.typescript
        p.zig
      ]))
      gitsigns-nvim
      neogit
      fidget-nvim
      mini-nvim
      telescope-nvim
      plenary-nvim
    ];
    extraLuaConfig = ''
      vim.loader.enable()

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.wrap = false
      vim.opt.expandtab = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.clipboard = "unnamedplus"
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.undofile = true

      vim.g.mapleader = " "

      vim.keymap.set("n", "<space>", "<nop>")
      vim.keymap.set("n", "<leader>e", ":Explore<cr>", { desc = "File explorer" })

      vim.keymap.set("v", "J", ":move '>+1<cr>gv=gv")
      vim.keymap.set("v", "K", ":move '<-2<cr>gv=gv")

      vim.keymap.set("n", "J", "mzJ`z")
      vim.keymap.set("n", "<c-d>", "<c-d>zz")
      vim.keymap.set("n", "<c-u>", "<c-u>zz")
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")

      vim.keymap.set("n", "<leader>w", ":write<cr>", { desc = "Save File" })
      vim.keymap.set("n", "<leader>q", ":quitall<cr>", { desc = "Quit all" })
      vim.keymap.set("n", "<leader>x", ":bdelete<cr>", { desc = "Close buffer" })

      vim.keymap.set("n", "<c-\\>", ":botright terminal<cr>")
      vim.keymap.set("n", "<c-t>", ":vsplit | terminal<cr>")

      vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
      vim.keymap.set("t", "<c-w>h", "<c-\\><c-n><c-w>h")
      vim.keymap.set("t", "<c-w>j", "<c-\\><c-n><c-w>j")
      vim.keymap.set("t", "<c-w>k", "<c-\\><c-n><c-w>k")
      vim.keymap.set("t", "<c-w>l", "<c-\\><c-n><c-w>l")

      vim.keymap.set("v", "<", "<gv")
      vim.keymap.set("v", ">", ">gv")

      vim.cmd.colorscheme "default"
      --vim.cmd.highlight "StatusLine guifg=NvimLightGrey3 guibg=NvimDarkGrey1"

      --require("fzf-lua").setup { "ivy", keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } } }
      --vim.keymap.set("n", "<leader>f", ":FzfLua files<cr>", { desc = "Find files" })
      --vim.keymap.set("n", "<leader>/", ":FzfLua live_grep<cr>", { desc = "Live grep" })
      --vim.keymap.set("n", "<leader><tab>", ":FzfLua buffers<cr>", { desc = "Buffers" })
      --vim.keymap.set("n", "<leader>hh", ":FzfLua helptags<cr>", { desc = "Help tags" })
      --vim.keymap.set("n", "<leader><leader>", ":FzfLua diagnostics_document<cr>", { desc = "Diagnostics" })
      --vim.keymap.set("n", "<leader>?", ":FzfLua command_history<cr>", { desc = "Command History" })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader><tab>", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader><leader>", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>?", builtin.command_history, { desc = "Command History" })

      require("neogit").setup {}
      vim.keymap.set("n", "<leader>g", ":Neogit kind=replace<cr>", { desc = "Neogit" })

      require("fidget").setup {}
      require("gitsigns").setup {}

      require("mini.splitjoin").setup {}
      require("mini.surround").setup {}
      require("mini.clue").setup({
        window = {
          delay = 0,
          width = "auto"
        },
        triggers = {
          { mode = "n", keys = "\\" },
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "i", keys = "<c-x>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<c-r>" },
          { mode = "c", keys = "<c-r>" },
          { mode = "n", keys = "<c-w>" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          require("mini.clue").gen_clues.builtin_completion(),
          require("mini.clue").gen_clues.g(),
          require("mini.clue").gen_clues.marks(),
          require("mini.clue").gen_clues.registers(),
          require("mini.clue").gen_clues.windows(),
          require("mini.clue").gen_clues.z(),
          { mode = "n", keys = "]", desc = "+Next" },
          { mode = "n", keys = "[", desc = "+Prev" },
        },
      })

      vim.lsp.config["gopls"] = {
        cmd = { "gopls" },
        root_markers = { "go.mod", "go.work" },
        filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
      }

      vim.lsp.config["nil_ls"] = {
        cmd = { "nil" },
        root_markers = { "flake.nix" },
        filetypes = { "nix" }
      }

      vim.lsp.config["rust-analyzer"] = {
        cmd = { "rust-analyzer" },
        root_markers = { "Cargo.toml" },
        filetypes = { "rust" },
      }

      vim.lsp.config["ts_ls"] = {
        cmd = { "typescript-language-server", "--stdio" },
        root_markers = { "package.json", "tsconfig.json" },
        filetypes = { "javascript", "typescript" }
      }

      vim.lsp.config["zls"] = {
        cmd = { "zls" },
        root_markers = { "build.zig" },
        filetypes = { "zig" },
      }

      vim.lsp.enable("gopls")
      vim.lsp.enable("nil_ls")
      vim.lsp.enable("rust-analyzer")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("zls")

      vim.keymap.set("n", "<leader>d", vim.diagnostic.setqflist, { desc = "Send Quickfix" })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          vim.print("LSP Attach " .. client.name)
          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
          end
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
        end,
      })

      vim.opt.completeopt = "menuone,popup,noselect,fuzzy"
      vim.o.winborder = "rounded"

      vim.keymap.set("i", "<c-space>", function()
        vim.lsp.completion.get()
      end)

      vim.diagnostic.config { virtual_text = true, virtual_lines = false }
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

      vim.cmd "autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })"
      vim.cmd "autocmd TermOpen,BufEnter term://* startinsert"

      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        indent = { enable = true }
      }

      vim.g.netrw_browse_split = 0

      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank()
        end,
      })
    '';
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
      battery.disabled = true;
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
    focusEvents = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
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
    EDITOR = "nvim";
  };

  home.file = {};

  programs.home-manager.enable = true;
}
