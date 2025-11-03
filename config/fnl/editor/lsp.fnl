(import/lua :null-ls :as none-ls)
(import :editor.keys (keymap))

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
                                          ; Handle completions for LSP that support them
                                          (when (client:supports_method vim.lsp.protocol.Methods.textDocument_inlineCompletion
                                                                        bufnr)
                                            (vim.lsp.inline_completion.enable true
                                                                              {: bufnr})
                                            (keymap :<c-f>
                                                    vim.lsp.inline_completion.get
                                                    {:mode :i
                                                     :desc "Accept Completion"})
                                            (keymap :<c-g>
                                                    vim.lsp.inline_completion.select
                                                    {:mode :i
                                                     :desc "Switch Completion"}))
																					; Handle formatting
																					(when (and (not (client:supports_method :textDocument/willSaveWaitUntil bufnr))
																										 (client:supports_method :textDocument/formatting bufnr))
																						(vim.api.nvim_create_autocmd :BufWritePre
																																				 {
																																				 :group (vim.api.nvim_create_augroup :bliss.lsp {:clear false})
																																				 :buffer bufnr
																																				 :callback (lambda []
																																										 (vim.lsp.buf.format {
																																																				 : bufnr
																																																				 :id client.id
																																																				 :timeout_ms 1000
																																																				 }))
																																				 })
																						)
																					)})
