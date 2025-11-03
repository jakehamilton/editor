(import/lua :nvim-tree)
(import :editor.keys (keymap))

(vim-global :loaded_netrw 1)
(vim-global :loaded_netrwPlugin 1)

(nvim-tree.setup {:sort {:sorter :case_sensitive} :filters {:dotfiles true}})

(keymap :<c-n> :<cmd>NvimTreeToggle<cr> {:mode :nvt :desc "Toggle Files"})
(keymap :<leader>tn :<cmd>NvimTreeToggle<cr> {:desc "Toggle Files"})
(keymap :<leader>gf :<cmd>NvimTreeFindFile<cr> {:mode :nvt :desc "Go To File"})
