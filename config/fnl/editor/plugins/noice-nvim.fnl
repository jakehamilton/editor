(import/lua :noice)

(noice.setup {:lsp {:progress {:enabled false}
                    :override {:vim.lsp.util.convert_input_to_markdown_lines true
                               :vim.lsp.util.stylize_markdown true}}
              :presets {:command_palette true
                        :long_message_to_split true
                        :inc_rename true
                        :lsp_doc_border true}
              :routes [{:filter {:event :msg_show
                                 :any [{:find "was properly created"}
                                       {:find "lines yanked"}
                                       {:find :written}]}
                        :opts {:skip true}}]})
