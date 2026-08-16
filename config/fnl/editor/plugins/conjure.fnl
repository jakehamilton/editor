(import-macros {: import : import/macro : import/lua} :editor.macros.import)

; Disable the popup. Use :ConjureLogSplit instead for logs.
(set vim.g.conjure#log#hud#enabled false)
(set vim.g.conjure#filetypes [:fennel])
