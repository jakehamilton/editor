(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/macro :editor.macros.vim (vim-global vim-option))

(import :editor.keys (keymap))

(keymap :<leader>bd :<cmd>BD<cr> {:desc "Delete Buffer"})
(keymap :<leader>bu :<cmd>BUNDO<cr> {:desc "Undo Delete Buffer"})

(vim-global :BufKillCreateMappings 0)
