{ config, pkgs, ... }:

{
  #home.file = {
  #  ".local/etc/nvim/shortcuts.vim".source = ./shortcuts.vim;
  #};

 # programs = {
  #  nixvim = {
      #enable = true;
      #defaultEditor = true;
      extraConfigVim = ''
        let mapleader = " "
        highlight LineNr guifg=#96B5B4
        set title
        set bg=dark
        set go=a
        set mouse=a
        set nohlsearch
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd

        " Some basics:
                nnoremap c "_c
                set nocompatible
                filetype plugin on
                syntax on
                set encoding=utf-8
        " Enable autocompletion:
                set wildmode=longest,list,full
        " Disables automatic commenting on newline:
                autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
        " Perform dot commands over visual blocks:
                vnoremap . :normal .<CR>
        " Goyo plugin makes text more readable when writing prose:
                map <leader>g :Goyo \| set linebreak<CR>
        " Spell-check set to <leader>o, 'o' for 'orthography':
                map <leader>o :setlocal spell! spelllang=en_us<CR>
        " Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
                set splitbelow splitright

        " Shortcutting split navigation, saving a keypress:
                map <C-h> <C-w>h
                map <C-j> <C-w>j
                map <C-k> <C-w>k
                map <C-l> <C-w>l

        " Replace ex mode with gq
                map Q gq

        " Check file in shellcheck:
                map <leader>s :!clear && ${pkgs.shellcheck}/bin/shellcheck -x %<CR>

        " Replace all is aliased to S.
                nnoremap S :%s//g<Left><Left>

        " Open corresponding .pdf/.html or preview
                map <leader>p :!opout.sh "%:p"<CR>

        " Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
        if &diff
            highlight! link DiffText MatchParen
        endif

        " Function for toggling the bottom statusbar:
        let s:hidden_all = 0
        function! ToggleHiddenAll()
            if s:hidden_all  == 0
                let s:hidden_all = 1
                set showmode
                set ruler
                set laststatus=2
                set showcmd
                set number
                set relativenumber
            else
                let s:hidden_all = 0
                set noshowmode
                set noruler
                set laststatus=0
                set noshowcmd
                set nonumber
                set norelativenumber
            endif
        endfunction
        nnoremap <leader>h :call ToggleHiddenAll()<CR>

        " source ~/.local/etc/nvim/shortcuts.vim
      '';
      extraConfigLuaPre = ''
      '';
      extraConfigLua = ''
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.opt.termguicolors = true
        require("nvim-tree").setup()
        vim.keymap.set('n', '<leader>n', '<cmd>NvimTreeFocus<cr>')
        vim.keymap.set('n', '<leader>N', '<cmd>NvimTreeToggle<cr>')
      '';
      extraConfigLuaPost = ''
      '';
      clipboard = {
        providers = {
          wl-copy = {
            enable = true;
          };
        };
      };
      autoCmd = [
        {
          command = "!createshortcuts.sh";
          event = [
            "BufWritePost"
          ];
          pattern = [
            "bm-files"
            "bm-dirs"
          ];
        }
      ];
      plugins = {
        #{
        #  plugin = nord-nvim;
        #  type = "lua";
        #  config = ''
        #    vim.g.nord_disable_background = true
        #    require('nord').set()
        #  '';
        #}
        vim-surround = {
          enable = true;
        };

        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = {
              action = "find_files";
              options = {
                desc = "Telescope Find Files";
              };
            };

            "<leader>fg" = {
              action = "live_grep";
              options = {
                desc = "Telescope Live Grep";
              };
            };

            "<leader>fb" = {
              action = "buffers";
              options = {
                desc = "Telescope Buffers";
              };
            };

            "<leader>fh" = {
              action = "help_tags";
              options = {
                desc = "Telescope Help";
              };
            };
          };
        };

        goyo = {
          enable = true;
        };

        treesitter = {
          enable = true;

          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            rust
            go
            zig
            c
            json
            lua
            make
            markdown
            nix
            regex
            toml
            vim
            vimdoc
            xml
            yaml
          ];
        };

        nvim-tree = {
          enable = true;
        };

        web-devicons = {
          enable = true;
          settings = {
            colors_icons = true;
            strict = true;
          };
        };

        commentary = {
          enable = true;
        };

        vim-css-color = {
          enable = true;
        };

        nix = {
          enable = true;
        };

        fugitive = {
          enable = true;
        };
      };
      extraPlugins = with pkgs.vimPlugins; [
        {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
            map <leader>v :VimwikiIndex<CR>
            let g:vimwiki_list = [{'path': '~/docs/notes', 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
      ];
      viAlias = true;
      vimAlias = true;
      #vimdiffAlias = true;
  #  };
  #};
}
