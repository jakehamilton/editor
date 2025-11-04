(import :editor.keys (keymap))

(var scratch-buf nil)
(var scratch-win nil)

(fn toggle-fennel-scratch []
  (if (and scratch-win (vim.api.nvim_win_is_valid scratch-win))
      (do
        (vim.api.nvim_win_close scratch-win true)
        (set scratch-win nil))
      (do
        (when (or (not scratch-buf) 
                  (not (vim.api.nvim_buf_is_valid scratch-buf)))
          (set scratch-buf (vim.api.nvim_create_buf false true))
          (vim.api.nvim_buf_set_option scratch-buf :filetype :fennel)
          (vim.api.nvim_buf_set_option scratch-buf :bufhidden :hide)
          (vim.api.nvim_buf_set_name scratch-buf "fennel-scratch"))
        (vim.cmd :vsplit)
        (set scratch-win (vim.api.nvim_get_current_win))
        (vim.api.nvim_win_set_buf scratch-win scratch-buf))))

(keymap :<leader>ts toggle-fennel-scratch {:desc "Toggle Scratchpad"})
