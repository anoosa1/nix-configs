# modules/pkgs/neovim.nix
{
  inputs,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    packages.neovim = (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        {
          config = {
            vim = {
              notes = {
                obsidian = {
                  enable = true;

                  setupOpts = {
                    legacy_commands = false;

                    workspaces = [
                      {
                        name = "notes";
                        path = "~/docs/notes";
                      }
                    ];
                    completion = {
                      nvim-cmp = true;
                    };

                    daily_notes = {
                      date_format = "%Y-%m-%d";
                      folder = "journals";
                    };
                  };
                };
              };

              keymaps = [
                {
                  key = "<leader>h";
                  mode = "n";
                  silent = true;
                  action = ":set number!<CR>:set relativenumber!<CR>";
                }
              ];

              binds = {
                whichKey = {
                  enable = true;
                };
              };

              clipboard = {
                enable = true;
                registers = "unnamedplus";
              };

              extraPlugins = {
                #vimwiki = {
                #  package = pkgs.vimPlugins.vimwiki;
                #  setup = "vim.g.vimwiki_list = {{path = '~/docs/notes', syntax = 'markdown', ext = 'md'}}";
                #};

                goyo = {
                  package = pkgs.vimPlugins.goyo-vim;
                  setup = "vim.keymap.set('n', '<leader>fy', ':Goyo<CR>', { desc = 'Toggle Goyo' })";
                };
              };

              telescope = {
                enable = true;
              };

              languages = {
                markdown = {
                  enable = true;

                  extensions = {
                    render-markdown-nvim = {
                      enable = true;

                      setupOpts = {
                        preset = "obsidian";
                      };
                    };
                  };

                  format = {
                    enable = true;
                  };

                  treesitter = {
                    enable = true;
                  };
                };

                nix = {
                  enable = true;

                  lsp = {
                    enable = true;
                  };

                  extraDiagnostics = {
                    enable = true;
                  };

                  format = {
                    enable = true;
                  };

                  treesitter = {
                    enable = true;
                  };
                };
              };

              theme = {
                enable = true;
                name = "nord";
                style = "dark";
                transparent = true;
              };

              options = {
                shiftwidth = 2;
              };

              utility = {
                snacks-nvim = {
                  enable = true;
                };
              };
            };
          };
        }
      ];
    }).neovim;
  };
}
