(import :editor.keys (keymap))
(import/lua :telescope)

(telescope.setup)

(telescope.load_extension :fzf)
(telescope.load_extension :nerdy)

(keymap :<leader>ff "<cmd>Telescope git_files<cr>" {:desc "Find Files (Git)"})
(keymap :<leader>fF "<cmd>Telescope find_files hidden=true<cr>"
        {:desc "Find Files (Hidden)"})

(keymap :<leader>fg "<cmd>Telescope live_grep<cr>" {:desc "Search Files (Git)"})
(keymap :<leader>fG "<cmd>Telescope live_grep hidden=true<cr>"
        {:desc "Search Files (Hidden)"})

(keymap :<leader>fi "<cmd>Telescope nerdy<cr>" {:desc "Find Icon"})
(keymap :<leader>fI "<cmd>Telescope nerdy_recents<cr>"
        {:desc "Find Recent Icon"})

(keymap :<leader>fb "<cmd>Telescope buffers<cr>" {:desc "Find Buffer"})
