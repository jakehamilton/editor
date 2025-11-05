{ config }:

{
  config.packages.default = config.packages.neovim;

  config.packages.neovim = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    package =
      {
        pkgs,
        lib,
        callPackage,
        vimPlugins,
        neovim-unwrapped,
        ...
      }:
      let
        pname = "editor";

        wrap = callPackage "${config.inputs.gift-wrap.result}/wrapper.nix" { };

        basePackage = neovim-unwrapped;

        inherit (basePackage) lua;
        inherit (lua.pkgs) luaLib;

        luaEnv = lua.withPackages (
          packages: with packages; [
            fennel
            luafilesystem
          ]
        );

        plugins = import ./plugins.nix {
          project = config;
          inherit pkgs;
          inherit lib;
        };
      in
      wrap {
        inherit pname;

        userConfig = ./config;

        aliases = [
          "vi"
          "vim"
        ];

        inherit basePackage;

        startPlugins =
          (with plugins; [
            # Code folding
            nvim-ufo

            # Miscellaneous LSP integrations
            none-ls

            # Refactor code
            refactoring-nvim
          ])
          ++ (with vimPlugins; [
            # Utilities required by other plugins
            plenary-nvim

            # Syntax and text objects
            nvim-treesitter.withAllGrammars

            # Needed for other plugins to show icons
            mini-icons

            # Git status indicators
            gitsigns-nvim

            # Key binding conveniences
            which-key-nvim

            # Needed for nvim-ufo
            promise-async

            # File tree
            nvim-tree-lua

            # Tmux integration
            vim-tmux-navigator

            # Buffer management
            vim-bufkill

            # UI components
            nui-nvim

            # Notification views
            nvim-notify

            # Modern Neovim UI
            noice-nvim

            # Incremental rename
            inc-rename-nvim

            # Language server configurations (defaults)
            nvim-lspconfig

            # Fuzzy finding (also needed by other plugins)
            fzf-lua

            # Diagnostics panel
            trouble-nvim

            # Status line
            lualine-nvim

            # Smooth scrolling
            neoscroll-nvim

            # Search UI
            telescope-nvim
            # Fuzzy find in Telescope
            telescope-fzf-native-nvim

            # Easy commenting
            comment-nvim

            # List open files
            bufferline-nvim

            # Colored parenthesis & brackets
            rainbow-delimiters-nvim

            # Icon searching
            nerdy-nvim

            # Snippets
            luasnip

            # Completion
            nvim-cmp
            cmp-nvim-lsp
            cmp-fuzzy-buffer
            cmp-fuzzy-path
            cmp-cmdline
            cmp-cmdline-history
            cmp-dictionary
            cmp_luasnip

            # Auto closing parenthesis & brackets
            nvim-autopairs

            # Preview code actions
            actions-preview-nvim

            # LSP virtual text
            lsp_lines-nvim

            # Session management
            auto-session

            # Dashboard
            dashboard-nvim

            # Formatting arbitrary files
            conform-nvim

            # Lisp parenthesis management
            nvim-paredit
            nvim-parinfer

            # Lisp scratch pad (Fennel)
            conjure

            # Indent guides
            indent-blankline-nvim-lua

            # Surrounding text modification
            nvim-surround
          ]);

        optPlugins =
          (with plugins; [

          ])
          ++ (with vimPlugins; [
          ]);

        extraPackages = with pkgs; [
          # Lua & Fennel
          fnlfmt
          fennel-ls
          lua-language-server

          # Go
          gopls
          gomodifytags
          impl
          gofumpt
          goimports-reviser

          # Rust
          rust-analyzer

          # Markdown
          markdownlint-cli
          codespell

          # Nix
          statix
          deadnix
          nixfmt
          nixd

          # Protobuf
          buf

          # Spelling
          codespell

          # EditorConfig
          editorconfig-checker

          # Godot
          gdtoolkit_4

          # JS & TS
          prettier
          prettierd
          typescript-language-server

          # Prisma
          prisma

          # Shell
          shellharden
          bash-language-server

          # GraphQL
          graphql-language-service-cli

          # Python
          pyright

          # Tailwind
          tailwindcss-language-server

          # Assembly
          asm-lsp

          # Copilot
          copilot-language-server

          # Frontend
          vscode-langservers-extracted

          # File searching
          ripgrep

          # Needed by fuzzy_path
          fd
        ];

        extraInitLua = ''
          package.path = "${luaLib.genLuaPathAbsStr luaEnv};$LUA_PATH" .. package.path
          package.cpath = "${luaLib.genLuaCPathAbsStr luaEnv};$LUA_CPATH" .. package.cpath

          -- Set up Fennel with full environment access
          local fennel = require("fennel")
          local config_path = vim.split(vim.o.runtimepath, ',')[1]
          local fnl_path = config_path .. "/pack/${pname}/start/init-plugin/fnl"

          -- Configure Fennel paths
          fennel.path = fnl_path .. "/?.fnl;" .. fnl_path .. "/?/init.fnl"
          fennel["macro-path"] = fnl_path .. "/?.fnl;" .. fnl_path .. "/?/init-macros.fnl;" .. fnl_path .. "/?/init.fnl"

          -- Set up compiler options with full environment access
          local compiler_options = {
            correlate = true,
            useMetadata = true,
            ["compiler-env"] = _G,  -- Full access to globals like vim
            allowedGlobals = false,  -- Disable whitelist, allow all globals
          }

          -- Custom error handler
          local function error_handler(err)
            vim.notify(
              "Fennel compilation error:\n" .. tostring(err),
              vim.log.levels.ERROR
            )
            print("\n=== FENNEL ERROR ===")
            print(err)
            print("====================\n")
            return err
          end

          -- Add Fennel searcher
          table.insert(package.loaders or package.searchers, function(module_name)
            local filename = fennel["search-module"](module_name, fennel.path)
            if filename then
              return function()
                local is_macro = module_name:match("%.macros%.")

                local ok, result = xpcall(
                  function()
                    if is_macro then
                      return fennel.dofile(filename, compiler_options)
                    else
                      -- Read, prepend, and eval
                      local f = io.open(filename, "r")
                      if not f then error("Could not open file: " .. filename) end
                      local content = f:read("*all")
                      f:close()

                      local prepended = '(import-macros {: import : import/macro : import/lua} :editor.macros.import)\n(import-macros {: export } :editor.macros.export)\n(import-macros {: vim-option : vim-global} :editor.macros.vim)\n' .. content
                      return fennel.eval(prepended, vim.tbl_extend("force", compiler_options, {
                        filename = filename
                      }))
                    end
                  end,
                  error_handler
                )

                if ok then
                  return result
                else
                  error(result)
                end
              end
            end
          end)
        '';
      };
  };
}
