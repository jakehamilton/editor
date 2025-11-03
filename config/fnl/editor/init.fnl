(import :editor.options)

(import :editor.plugins.noice-nvim)
(import :editor.plugins.mini-icons)
(import :editor.plugins.gitsigns)
(import :editor.plugins.which-key)
(import :editor.plugins.nvim-ufo)
(import :editor.plugins.nvim-tree)
(import :editor.plugins.tmux-navigator)
(import :editor.plugins.vim-bufkill)
(import :editor.plugins.refactoring-nvim)
(import :editor.plugins.trouble-nvim)
(import :editor.plugins.lualine-nvim)
(import :editor.plugins.neoscroll-nvim)
(import :editor.plugins.comment-nvim)
(import :editor.plugins.rainbow-delimiters)

(import :editor.theme (setup :as setup-theme))
(import :editor.keys (setup :as setup-keys))
(import :editor.lsp)

(setup-theme)
(setup-keys)

; BufferLine has an issue with its highlight groups being cleared. Because of
; this it has to be imported *after* the theme has been set up.
(import :editor.plugins.bufferline-nvim)
