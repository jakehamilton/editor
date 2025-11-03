(import :editor.keys (keymap))
(import/lua :trouble)

(trouble.setup
	{
	:auto_preview false
	:focus true
	})

(keymap :tt "<cmd>Trouble diagnostics toggle<cr>" {:mode :nx :desc "Toggle Trouble"})
(keymap :tT "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" {:mode :nx :desc "Toggle Trouble (Buffer)"})
