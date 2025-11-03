(import :editor.keys (keymap))

(vim-global :tmux_navigator_disable_when_zoomed 1)
(vim-global :tmux_navigator_no_mappings 1)

(keymap :<m-h> :<cmd>TmuxNavigateLeft<cr> {:desc "Navigate Left"})

(keymap :<m-j> :<cmd>TmuxNavigateDown<cr> {:desc "Navigate Down"})

(keymap :<m-k> :<cmd>TmuxNavigateUp<cr> {:desc "Navigate Up"})

(keymap :<m-l> :<cmd>TmuxNavigateRight<cr> {:desc "Navigate Right"})
