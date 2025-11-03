(import/lua :which-key)

(fn keymap-options [key options]
  (var binding [key])
  (each [name value (pairs options)]
    (tset binding name value))
  (which-key.add [binding]))

(fn keymap-handler [key handler]
  (var binding [key handler])
  (which-key.add [binding]))

(fn keymap-handler-options [key handler options]
  (var binding [key handler])
  (each [name value (pairs options)]
    (tset binding name value))
  (which-key.add [binding]))

(fn keymap [key ?handler ?options]
  (let [has-handler? (not= nil ?handler)
        has-options? (not= nil ?options)]
    (if (and has-handler? has-options?)
        (keymap-handler-options key ?handler ?options)
        (if has-options?
            (keymap-options key ?options)
            (keymap-handler key ?handler)))))

(fn setup []
  (keymap :<leader>q :<cmd>wqa<cr> {:desc "Save & Quit"})
  (keymap :<leader>Q :<cmd>qa!<cr> {:desc :Quit})
  (keymap :<leader>w :<cmd>w<cr> {:desc :Save})
  (keymap :<leader>W :<cmd>wa<cr> {:desc "Save All"})
  (keymap :<leader>ch :<cmd>noh<cr> {:desc "Clear Highlight"})
  (keymap :<leader>cs "<cmd>let @/=\"\"<cr>" {:desc "Clear Search"})
  (keymap :<c-o> "<c-\\><c-n>" {:mode :t :desc "Leave Terminal"}))

(export setup keymap)
