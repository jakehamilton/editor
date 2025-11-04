(import :editor.theme (highlight colors))
(import/lua :ibl :as indentblank-line)
(import/lua :ibl.hooks :as hooks)

(indentblank-line.setup {:exclude {:filetypes [:lspinfo
                                               :packer
                                               :checkhealth
                                               :help
                                               :man
                                               :TelescopePrompt
                                               :TelescopeResults
                                               :NvimTree
                                               :dashboard
                                               ""]}
                         :indent {:char "┆"
                                  :highlight [:IBLBase
                                              :IBLSakura
                                              :IBLMint
                                              :IBLSky
                                              :IBLPeach
                                              :IBLBerry]}})
