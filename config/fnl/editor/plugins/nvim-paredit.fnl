(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import :editor.keys (keymap))
(import/lua :nvim-paredit)

(nvim-paredit.setup)
