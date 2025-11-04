(import :editor.keys (keymap))
(import/lua :actions-preview)

(actions-preview.setup)

(keymap :pa actions-preview.code_actions {:desc "Code Actions"})
