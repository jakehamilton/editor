(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/lua :ufo)

(ufo.setup {:provider_selector (lambda [bufnr filetype buftype]
                                 [:treesitter :indent])})
