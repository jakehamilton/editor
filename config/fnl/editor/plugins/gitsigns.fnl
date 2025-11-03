(import :editor.keys (keymap))
(import/lua :gitsigns)

(macro schedule [& body]
	`(vim.schedule (lambda []
									 ,(unpack body))))

(gitsigns.setup {
								:trouble true
								:current_line_blame true
								:on_attach (lambda [bufnr]
														 (keymap "[c"
																		 (lambda []
																			 (if vim.wo.diff
																					 "[c"
																					 (schedule (gitsigns.prev_hunk))))
																		 {:mode :nx :buffer bufnr :desc "Previous Hunk"})
														 (keymap "]c"
																		 (lambda []
																			 (if vim.wo.diff
																					 "[c"
																					 (schedule (gitsigns.next_hunk))))
																		 {:mode :nx :buffer bufnr :desc "Next Hunk"})
														 (keymap :<leader>hs "<cmd>Gitsigns stage_hunk<cr>" {:mode :n :buffer bufnr :desc "Stage Hunk"})
														 (keymap :<leader>hS "<cmd>Gitsigns stage_buffer<cr>" {:mode :n :buffer bufnr :desc "Stage Buffer"})
														 (keymap :<leader>hr "<cmd>Gitsigns reset_hunk<cr>" {:mode :n :buffer bufnr :desc "Reset Hunk"})
														 (keymap :<leader>hR "<cmd>Gitsigns reset_buffer<cr>" {:mode :n :buffer bufnr :desc "Reset Buffer"})
														 (keymap :<leader>hu "<cmd>Gitsigns undo_stage_hunk<cr>" {:mode :n :buffer bufnr :desc "Undo Stage Hunk"})
														 (keymap :<leader>hp "<cmd>Gitsigns preview_hunk<cr>" {:mode :n :buffer bufnr :desc "Preview Hunk"})
														 (keymap :<leader>hb (lambda [] (gitsigns.blame_line {:full true})) {:mode :n :buffer bufnr :desc "Blame Line"})
														 (keymap :<leader>hd "<cmd>Gitsigns diffthis<cr>" {:mode :n :buffer bufnr :desc "Diff"})
														 (keymap :<leader>hd (lambda [] (gitsigns.diffthis "~")) {:mode :n :buffer bufnr :desc "Diff (~)"})
														 (keymap :<leader>tb "<cmd>Gitsigns toggle_current_line_blame<cr>" {:mode :n :buffer bufnr :desc "Toggle Current Line Blame"})
														 (keymap :<leader>td "<cmd>Gitsigns toggle_deleted<cr>" {:mode :n :buffer bufnr :desc "Toggle Deleted"})
														 )})
