(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/lua :noice)

(vim.opt.shortmess:append :S)

(noice.setup {:messages {:view :mini :view_error :mini :view_warn :mini}
              :notify {:enabled true :view :mini}
              :lsp {:progress {:enabled false}
                    :hover {:silent true}
                    :message {:enabled true :view :mini}
                    :override {:vim.lsp.util.convert_input_to_markdown_lines true
                               :vim.lsp.util.stylize_markdown true}}
              :views {:mini {:timeout 1500}}
              :presets {:command_palette true
                        :long_message_to_split false
                        :inc_rename true
                        :lsp_doc_border true}
              :routes [;; Low-value messages.
                       {:filter {:event :notify :kind [:trace :debug :info]}
                        :opts {:skip true}}
                       ;; Everything else gets rerouted to the mini view.
                       {:filter {:event :notify} :view :mini}
                       ;; Editing
                       {:filter {:event :msg_show
                                 :any [{:find "was properly created"}
                                       {:find "lines yanked"}
                                       {:find :written}]}
                        :opts {:skip true}}
                       ;; Search
                       {:filter {:event :msg_show
                                 :any [{:find "E486: Pattern not found:"}
                                       {:find :search_count}
                                       {:find "search hit"}
                                       {:find "%[%d+/%d+%]"}]}
                        :opts {:skip true}}
                       {:filter {:event :notify
                                 :any [{:find "No information available"}]}
                        :opts {:skip true}}]})
