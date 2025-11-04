(import/lua :cmp)
(import/lua :luasnip)
(import/lua :nvim-autopairs.completion.cmp :as nvim-autopairs-cmp)

(cmp.setup {:experimental {:ghost_text true}
            :snippet {:expand (lambda [args]
                                (luasnip.lsp_expand args.body))}
            :window {:completion (cmp.config.window.bordered)
                     :documentation (cmp.config.window.bordered)}
            :mapping (cmp.mapping.preset.insert {:<c-e> (cmp.mapping.abort)
                                                 :<c-j> (cmp.mapping.scroll_docs 4)
                                                 :<c-k> (cmp.mapping.scroll_docs -4)
                                                 :<c-l> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                                              :select true})
                                                 :<c-n> (lambda [fallback]
                                                          (if (cmp.visible)
                                                              (cmp.select_next_item)
                                                              (if (luasnip.expand_or_jumpable)
                                                                  (luasnip.expand_or_jump)
                                                                  (cmp.complete))))
                                                 :<c-p> (lambda [fallback]
                                                          (if (cmp.visible)
                                                              (cmp.select_prev_item)
                                                              (if (luasnip.expand_or_jumpable)
                                                                  (luasnip.expand_or_jump)
                                                                  (cmp.complete))))})
            :sources (cmp.config.sources [{:name :nvim_lsp} {:name :luasnip}]
                                         [{:name :fuzzy_path}
                                          {:name :fuzzy_buffer}
                                          {:name :dictionary}])})

(cmp.setup.cmdline ":"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :cmdline}
                                                  {:name :cmdline_history}]
                                                 [{:name :fuzzy_path}])})

(cmp.setup.cmdline "/"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :fuzzy_buffer}])})

(cmp.setup.cmdline "?"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :fuzzy_buffer}])})

(cmp.event:on :confirm_done (nvim-autopairs-cmp.on_confirm_done))
