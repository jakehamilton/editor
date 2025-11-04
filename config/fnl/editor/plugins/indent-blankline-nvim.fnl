(import :editor.theme (highlight colors))
(import/lua :ibl :as indent-blankline)
(import/lua :ibl.hooks :as hooks)

(local highlights [:RainbowDelimiterText
                   :RainbowDelimiterSakura
                   :RainbowDelimiterMint
                   :RainbowDelimiterSky
                   :RainbowDelimiterPeach
                   :RainbowDelimiterBerry])

(indent-blankline.setup {:exclude {:filetypes [:lspinfo
                                               :packer
                                               :checkhealth
                                               :help
                                               :man
                                               :TelescopePrompt
                                               :TelescopeResults
                                               :NvimTree
                                               :dashboard
                                               ""]}
                         :indent {:char "┆"}
                         :highlight highlights})

(hooks.register hooks.type.SCOPE_HIGHLIGHT
                hooks.builtin.scope_highlight_from_extmark)
