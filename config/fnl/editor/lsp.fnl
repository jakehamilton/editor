(import/lua :null-ls :as none-ls)
(import/lua :lsp_lines :as lsp-lines)
(import :editor.keys (keymap))

(lsp-lines.setup)

(vim.diagnostic.config {:float {:focusable true
                                :source :always
                                :border :rounded}
                        :virtual_text false
                        :virtual_lines false})

(keymap :<leader>tl
        (lambda []
          (local config (vim.diagnostic.config))
          (vim.diagnostic.config {:virtual_lines (not config.virtual_lines)})))

(none-ls.setup {:sources [; Misc
                          none-ls.builtins.diagnostics.todo_comments
                          none-ls.builtins.diagnostics.trail_space
                          ; Fennel
                          none-ls.builtins.formatting.fnlfmt
                          ; Go
                          none-ls.builtins.code_actions.gomodifytags
                          none-ls.builtins.code_actions.impl
                          none-ls.builtins.formatting.gofumpt
                          none-ls.builtins.formatting.goimports_reviser
                          ; Text
                          none-ls.builtins.code_actions.proselint
                          none-ls.builtins.diagnostics.proselint
                          none-ls.builtins.diagnostics.codespell
                          none-ls.builtins.formatting.codespell
                          ; Refactoring code
                          none-ls.builtins.code_actions.refactoring
                          ; Nix linting
                          none-ls.builtins.diagnostics.deadnix
                          none-ls.builtins.formatting.nixfmt
                          ; Protobuf
                          none-ls.builtins.diagnostics.buf
                          none-ls.builtins.formatting.buf
                          ; Git
                          none-ls.builtins.diagnostics.commitlint
                          none-ls.builtins.code_actions.gitsigns
                          ; EditorConfig
                          none-ls.builtins.diagnostics.editorconfig_checker
                          ; Godot
                          none-ls.builtins.formatting.gdformat
                          ; JS & TS
                          (none-ls.builtins.formatting.prettierd.with {:condition (lambda [utils]
                                                                                    (not (or (utils.has_file :.eslintrc)
                                                                                             (utils.has_file :.eslintrc.js)
                                                                                             (utils.has_file :.eslintrc.ts))))})
                          ; Prisma
                          none-ls.builtins.formatting.prisma_format
                          ; Shell
                          none-ls.builtins.formatting.shellharden]})

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

(let [capabilities (vim.lsp.protocol.make_client_capabilities)]
  (set capabilities.textDocument.completion.completionItem.snippetSupport true)
  (vim.lsp.config :html {: capabilities})
  (vim.lsp.enable :html))

(let [capabilities (vim.lsp.protocol.make_client_capabilities)]
  (set capabilities.textDocument.completion.completionItem.snippetSupport true)
  (vim.lsp.config :jsonls {: capabilities})
  (vim.lsp.enable :jsonls))

(let [on_attach vim.lsp.config.eslint.on_attach]
  (vim.lsp.config :eslint
                  {:on_attach (lambda [client bufnr]
                                (when (not= nil on_attach)
                                  (on_attach client bufnr)
                                  (vim.api.nvim_create_autocmd :BufWritePre
                                                               {:buffer bufnr
                                                                :command :LspEslintFixAll})))})
  (vim.lsp.enable :eslint))

(vim.api.nvim_create_autocmd :LspAttach
                             {:callback (lambda [args]
                                          (var bufnr args.buf)
                                          (var client
                                               (vim.lsp.get_client_by_id args.data.client_id))
                                          ; Set omnifunc to use LSP
                                          (tset (. vim.bo bufnr) :omnifunc
                                                "v:lua.vim.lsp.omnifunc")
                                          ; Common bindings
                                          (keymap :gh vim.lsp.buf.hover
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Show Info"})
                                          (keymap :gd vim.lsp.buf.definition
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Go To Definition"})
                                          (keymap :gD vim.lsp.buf.declaration
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Go To Declaration"})
                                          (keymap :gi
                                                  vim.lsp.buf.implementation
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Go To Implementation"})
                                          (keymap :gr vim.lsp.buf.references
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Go To References"})
                                          (keymap :<leader>rn
                                                  vim.lsp.buf.rename
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc :Rename})
                                          (keymap :<c-k>
                                                  vim.lsp.buf.signature_help
                                                  {:mode :ni
                                                   :buffer bufnr
                                                   :desc "Show Signature"})
                                          (keymap "[d" vim.diagnostic.goto_prev
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Previous Diagnostic"})
                                          (keymap "]d" vim.diagnostic.goto_next
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Next Diagnostic"})
                                          (keymap :<leader>od
                                                  vim.diagnostic.open_float
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc "Open Diagnostic"})
                                          (keymap :<leader>rf
                                                  (lambda []
                                                    (vim.lsp.buf.format {:async true}))
                                                  {:mode :n
                                                   :buffer bufnr
                                                   :desc :Format})
                                          ; Handle completions for LSP that support them
                                          ; TODO: Enable this when the Neovim version is bumped
                                          ; (when (client:supports_method vim.lsp.protocol.Methods.textDocument_inlineCompletion
                                          ;                               bufnr)
                                          ;   (vim.lsp.inline_completion.enable true
                                          ;                                     {: bufnr})
                                          ;   (keymap :<c-f> ;           vim.lsp.inline_completion.get
                                          ;           {:mode :i ;            :desc "Accept Completion"})
                                          ;   (keymap :<c-g> ;           vim.lsp.inline_completion.select
                                          ;           {:mode :i ;            :desc "Switch Completion"}))
                                          ; Handle formatting
                                          (when (and (not (client:supports_method :textDocument/willSaveWaitUntil
                                                                                  bufnr))
                                                     (client:supports_method :textDocument/formatting
                                                                             bufnr))
                                            (vim.api.nvim_create_autocmd :BufWritePre
                                                                         {:group (vim.api.nvim_create_augroup :bliss.lsp
                                                                                                              {:clear false})
                                                                          :buffer bufnr
                                                                          :callback (lambda []
                                                                                      (vim.lsp.buf.format {: bufnr
                                                                                                           :id client.id
                                                                                                           :timeout_ms 1000}))})))})

(vim.lsp.inlay_hint.enable true)
