(import/lua :nvim-tree)
(import/lua :nvim-tree.api)
(import :editor.keys (keymap))

(vim-global :loaded_netrw 1)
(vim-global :loaded_netrwPlugin 1)

(fn on-attach [bufnr]
  (api.config.mappings.default_on_attach bufnr)
  (keymap :s api.node.open.vertical
          {:desc "Open (Vertical)" :buffer bufnr :noremap true})
  (keymap :S api.node.open.horizontal
          {:desc "Open (Horizontal)" :buffer bufnr :noremap true})
  (keymap :t api.node.open.t {:desc "Open (Tab)" :buffer bufnr :noremap true})
  (keymap :O api.node.run.system
          {:desc "Open (System)" :buffer bufnr :noremap true})
  (keymap :<c-r> api.tree.reload {:desc :Reload :buffer bufnr :noremap true})
  (keymap "?" api.tree.toggle_help {:desc :Help :buffer bufnr :noremap true}))

(nvim-tree.setup {:sort {:sorter :case_sensitive}
                  :filters {:dotfiles true}
                  :view {:width 40}
                  :on_attach on-attach})

(keymap :<c-n> :<cmd>NvimTreeToggle<cr>
        {:mode :nvt :desc "Toggle Files" :noremap true})

(keymap :<leader>tn :<cmd>NvimTreeToggle<cr> {:desc "Toggle Files"})
(keymap :<leader>gf :<cmd>NvimTreeFindFile<cr> {:mode :nvt :desc "Go To File"})
