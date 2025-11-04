(import :editor.keys (keymap))
(import/lua :auto-session)

(auto-session.setup {:enabled true
                     :auto_save true
                     :auto_restore true
                     :bypass_save_filetypes [:NvimTree :dashboard]
                     :auto_create true
                     :use_git_branch true})

(keymap :<leader>fs "<cmd>Telescope session-lens<cr>" {:desc "Find Session"})
