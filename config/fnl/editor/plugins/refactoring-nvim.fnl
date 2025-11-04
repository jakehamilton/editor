(import :editor.keys (keymap))
(import/lua :refactoring)

(refactoring.setup)

(keymap :<leader>re "<cmd>Refactor extract<cr>" {:desc :Extract :mode :x})
(keymap :<leader>rf "<cmd>Refactor extract_to_file<cr>"
        {:desc "Extract To File" :mode :x})

(keymap :<leader>ri "<cmd>Refactor inline_var<cr>"
        {:desc "Inline Var" :mode :nx})

(keymap :<leader>rI "<cmd>Refactor inline_func<cr>"
        {:desc "Inline Function" :mode :n})

(keymap :<leader>rb "<cmd>Refactor extract_block<cr>"
        {:desc "Extract Block" :mode :n})

(keymap :<leader>rB "<cmd>Refactor extract_block_to_file<cr>"
        {:desc "Extract Block To File" :mode :n})
