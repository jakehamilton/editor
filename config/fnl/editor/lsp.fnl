(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/lua :null-ls)
(import :editor.keys (keymap))

(fn configure-null-ls []
  (local sources [;; Misc
                  null-ls.builtins.diagnostics.todo_comments
                  null-ls.builtins.diagnostics.trail_space
                  ;; Fennel
                  null-ls.builtins.formatting.fnlfmt
                  ;; JS & TS
                  null-ls.builtins.formatting.prettierd
                  ;; Go
                  null-ls.builtins.code_actions.gomodifytags
                  null-ls.builtins.code_actions.impl
                  null-ls.builtins.formatting.gofumpt
                  null-ls.builtins.formatting.goimports_reviser
                  ;; Text
                  null-ls.builtins.diagnostics.codespell
                  null-ls.builtins.formatting.codespell
                  ;; Refactoring code
                  null-ls.builtins.code_actions.refactoring
                  ;; Nix linting
                  null-ls.builtins.diagnostics.deadnix
                  null-ls.builtins.formatting.nixfmt
                  ;; Protobuf
                  null-ls.builtins.diagnostics.buf
                  null-ls.builtins.formatting.buf
                  ;; Git
                  null-ls.builtins.code_actions.gitsigns
                  ;; EditorConfig
                  null-ls.builtins.diagnostics.editorconfig_checker
                  ;; Godot
                  null-ls.builtins.formatting.gdformat
                  ;; Prisma
                  null-ls.builtins.formatting.prisma_format
                  ;; Shell
                  null-ls.builtins.formatting.shellharden])
  (null-ls.setup {: sources}))

(fn configure-diagnostics []
  (vim.lsp.inlay_hint.enable true)
  (vim.diagnostic.config {:float {:focusable true
                                  :source :always
                                  :border :rounded}
                          :virtual_text false
                          :virtual_lines false}))

(fn null-ls-can-format? [bufnr]
  (local filetype (vim.api.nvim_get_option_value :filetype {:buf bufnr}))
  (local source?
         (null-ls.is_registered {: filetype :method null-ls.methods.FORMATTING}))
  (local attached?
         (not (vim.tbl_isempty (vim.lsp.get_clients {: bufnr :name :null-ls}))))
  (and source? attached?))

(fn format-buffer [bufnr options]
  (local use-null-ls (null-ls-can-format? bufnr))
  (local filter (lambda [client]
                  (if use-null-ls
                      (= client.name :null-ls)
                      (and (not= client.name :null-ls)
                           (not= client.name :eslint)))))
  (local clients
         (vim.lsp.get_clients {: bufnr :method :textDocument/formatting}))
  (local formatters (vim.tbl_filter filter clients))
  (when (not (vim.tbl_isempty formatters))
    (vim.lsp.buf.format (vim.tbl_extend :force {: bufnr : filter}
                                        (or options {})))))

(fn eslint-attached? [bufnr]
  (not (vim.tbl_isempty (vim.lsp.get_clients {: bufnr :name :eslint}))))

(fn eslint-fix-buffer [bufnr]
  (when (eslint-attached? bufnr)
    (vim.api.nvim_buf_call bufnr
                           (lambda []
                             (vim.cmd :LspEslintFixAll)))))

(fn fix-and-format-buffer [bufnr options]
  (eslint-fix-buffer bufnr)
  (format-buffer bufnr options))

(fn on-lsp-attach [event]
  (local bufnr event.buf)
  ;; Common bindings
  (keymap :gh vim.lsp.buf.hover {:mode :n :buffer bufnr :desc "Show Info"})
  (keymap :gd vim.lsp.buf.definition
          {:mode :n :buffer bufnr :desc "Go To Definition"})
  (keymap :gD vim.lsp.buf.declaration
          {:mode :n :buffer bufnr :desc "Go To Declaration"})
  (keymap :gi vim.lsp.buf.implementation
          {:mode :n :buffer bufnr :desc "Go To Implementation"})
  (keymap :gr vim.lsp.buf.references
          {:mode :n :buffer bufnr :desc "Go To References"})
  (keymap :<leader>rn vim.lsp.buf.rename {:mode :n :buffer bufnr :desc :Rename})
  (keymap :<c-k> vim.lsp.buf.signature_help
          {:mode :ni :buffer bufnr :desc "Show Signature"})
  (keymap "[d" (lambda []
                 (vim.diagnostic.jump {:count -1 :float true}))
          {:mode :n :buffer bufnr :desc "Previous Diagnostic"})
  (keymap "]d" (lambda []
                 (vim.diagnostic.jump {:count 1 :float true}))
          {:mode :n :buffer bufnr :desc "Next Diagnostic"})
  (keymap :<leader>od vim.diagnostic.open_float
          {:mode :n :buffer bufnr :desc "Open Diagnostic"})
  (keymap :<leader>bf
          (lambda []
            (fix-and-format-buffer bufnr {:timeout_ms 1000}))
          {:mode :n :buffer bufnr :desc :Format}))

(fn toggle-virtual-lines []
  (local config (vim.diagnostic.config))
  (vim.diagnostic.config {:virtual_lines (not config.virtual_lines)}))

(fn configure-keybindings []
  (keymap :<leader>tl toggle-virtual-lines)
  (vim.api.nvim_create_autocmd :LspAttach
                               {:group (vim.api.nvim_create_augroup :bliss.lsp.attach
                                                                    {:clear true})
                                :callback on-lsp-attach}))

(fn configure-format-on-save []
  (local format-group
         (vim.api.nvim_create_augroup :bliss.lsp.format {:clear true}))
  (vim.api.nvim_create_autocmd :BufWritePre
                               {:group format-group
                                :callback (lambda [event]
                                            (fix-and-format-buffer event.buf
                                                                   {:timeout_ms 1000}))}))

(fn configure-default-lsp-config []
  (local capabilities (vim.lsp.protocol.make_client_capabilities))
  (set capabilities.textDocument.completion.completionItem.snippetSupport true)
  (vim.lsp.config "*" {: capabilities}))

(configure-null-ls)
(configure-diagnostics)
(configure-keybindings)
(configure-format-on-save)
(configure-default-lsp-config)

(vim.lsp.config :ts_ls
                {:init_options {:preferences {:importModuleSpecifierPreference :non-relative
                                              :quotePreference :double
                                              :preferTypeOnlyAutoImports true
                                              :includePackageJsonAutoImports :auto
                                              :includeInlayParameterNameHints :all
                                              :includeInlayFunctionLikeReturnTypeHints true
                                              :includeInlayVariableTypeHints true
                                              :includeInlayPropertyDeclarationTypeHints true
                                              :includeInlayEnumMemberValueHints true
                                              :autoImportFileExcludePatterns [:**/dist/**
                                                                              :**/build/**
                                                                              :**/generated/**]
                                              :importModuleSpecifierEnding :minimal}}})

(vim.lsp.enable :asm_lsp)
(vim.lsp.enable :astro)
(vim.lsp.enable :bashls)
(vim.lsp.enable :copilot)
(vim.lsp.enable :cssls)
(vim.lsp.enable :fennel_ls)
(vim.lsp.enable :gopls)
(vim.lsp.enable :graphql)
(vim.lsp.enable :lua_ls)
(vim.lsp.enable :nixd)
(vim.lsp.enable :pyright)
(vim.lsp.enable :rust_analyzer)
(vim.lsp.enable :statix)
(vim.lsp.enable :tailwindcss)
(vim.lsp.enable :ts_ls)
(vim.lsp.enable :html)
(vim.lsp.enable :jsonls)
(vim.lsp.enable :eslint)
