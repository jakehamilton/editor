(import/lua :ufo)

(ufo.setup {:provider_selector (lambda [bufnr filetype buftype]
                                 [:treesitter :indent])})
