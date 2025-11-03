(import :editor.keys (keymap))

(keymap :<leader>b {:group :buffer})
(keymap :<leader>bd :<cmd>BD<cr> {:desc "Delete Buffer"})
(keymap :<leader>bu :<cmd>BUNDO<cr> {:desc "Undo Delete Buffer"})

(vim-global :BufKillCreateMappings 0)
