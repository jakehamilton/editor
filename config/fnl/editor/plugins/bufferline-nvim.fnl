(import :editor.keys (keymap))
(import :editor.theme (colors))
(import/lua :bufferline)

(bufferline.setup {:options {:mode :buffers
                             ; I wanted to use "slope", but apparently Bufferline is incapable of
                             ; handling the coloring of tabs and separators how I want.
                             ; Instead no separator is used.
                             :separator_style ["" ""]
														 :indicator {:icon ">"}
                             :enforce_regular_tabs true
                             :close_icon ""
                             :buffer_close_icon ""
                             :left_mouse_command nil
                             :middle_mouse_command nil
                             :right_mouse_command nil
                             :custom_filter (lambda [bufnr bufnums]
                                              (local buffer (. vim.bo bufnr))
                                              (and (not= buffer.filetype
                                                         :dashboard)
                                                   (not= buffer.filetype
                                                         :NvimTree)
                                                   (not= buffer.filetype
                                                         :Trouble)
                                                   (not= buffer.filetype
                                                         :TelescopePrompt)))
                             :offsets [{:filetype :NvimTree
                                        :text :Files
                                        :highlight :Directory
                                        :separator true
                                        :text_align :center}]
                             :pick {:alphabet :abcdefghijklmopqrstuvwxyz}
                             :numbers (lambda [opts]
                                        (string.format "%s"
                                                       (opts.raise opts.ordinal)))}
                   ; TODO: There seem to be a LOT of highlight groups that
                   ; don't seem to work. Currently `colors.sky` is being used to
                   ; make the ones I don't know about visible. However, at the time
                   ; of writing, none of these appear. Perhaps this is all I need
                   ; for my usage? If so, the entries with `colors.sky` set can
                   ; be removed.
                   :highlights {:fill {:fg colors.surface
                                       :bg colors.surface}
                                :background {:fg colors.text
                                             :bg colors.surface}
                                :tab {:fg colors.text
                                      :bg colors.surface}
                                :tab_selected {:fg colors.sakura
                                               :bg colors.surface}
                                :tab_separator {:fg colors.sky :bg colors.sky}
                                :tab_separator_selected {:fg colors.sky
                                                         :bg colors.sky}
                                :tab_close {:fg colors.surface
                                            :bg colors.surface}
                                :separator {:fg colors.surface
                                            :bg colors.none}
                                :separator_selected {:fg colors.surface
                                                     :bg colors.none}
                                :separator_visible {:fg colors.surface
                                                    :bg colors.none}
                                :close_button {:fg colors.surface
                                               :bg colors.surface}
                                :close_button_visible {:fg colors.surface
                                                       :bg colors.surface}
                                :close_button_selected {:fg colors.surface
                                                        :bg colors.surface}
                                :buffer {:fg colors.text
                                         :bg colors.surface}
                                :buffer_visible {:fg colors.text
                                                 :bg colors.surface}
                                :buffer_selected {:fg colors.text
                                                  :bg colors.surface}
                                :numbers {:fg colors.text
                                          :bg colors.surface}
                                :numbers_visible {:fg colors.text
                                                  :bg colors.surface}
                                :numbers_selected {:fg colors.text
                                                   :bg colors.surface}
                                :diagnostic {:fg colors.sky :bg colors.sky}
                                :diagnostic_visible {:fg colors.sky
                                                     :bg colors.sky}
                                :diagnostic_selected {:fg colors.sky
                                                      :bg colors.sky}
                                :hint {:fg colors.sky :bg colors.sky}
                                :hint_visible {:fg colors.sky :bg colors.sky}
                                :hint_selected {:fg colors.sky :bg colors.sky}
                                :hint_diagnostic {:fg colors.sky
                                                  :bg colors.sky}
                                :hint_diagnostic_visible {:fg colors.sky
                                                          :bg colors.sky}
                                :hint_diagnostic_selected {:fg colors.sky
                                                           :bg colors.sky}
                                :info {:fg colors.sky :bg colors.sky}
                                :info_visible {:fg colors.sky :bg colors.sky}
                                :info_selected {:fg colors.sky :bg colors.sky}
                                :info_diagnostic {:fg colors.sky
                                                  :bg colors.sky}
                                :info_diagnostic_visible {:fg colors.sky
                                                          :bg colors.sky}
                                :info_diagnostic_selected {:fg colors.sky
                                                           :bg colors.sky}
                                :warning {:fg colors.sky :bg colors.sky}
                                :warning_visible {:fg colors.sky
                                                  :bg colors.sky}
                                :warning_selected {:fg colors.sky
                                                   :bg colors.sky}
                                :warning_diagnostic {:fg colors.sky
                                                     :bg colors.sky}
                                :warning_diagnostic_visible {:fg colors.sky
                                                             :bg colors.sky}
                                :warning_diagnostic_selected {:fg colors.sky
                                                              :bg colors.sky}
                                :error {:fg colors.sky :bg colors.sky}
                                :error_visible {:fg colors.sky :bg colors.sky}
                                :error_selected {:fg colors.sky :bg colors.sky}
                                :error_diagnostic {:fg colors.sky
                                                   :bg colors.sky}
                                :error_diagnostic_visible {:fg colors.sky
                                                           :bg colors.sky}
                                :error_diagnostic_selected {:fg colors.sky
                                                            :bg colors.sky}
                                :modified {:fg colors.text :bg colors.surface}
                                :modified_visible {:fg colors.text
                                                   :bg colors.surface}
                                :modified_selected {:fg colors.text
                                                    :bg colors.surface}
                                :duplicate {:fg colors.text :bg colors.surface}
                                :duplicate_selected {:fg colors.text
                                                     :bg colors.surface}
                                :duplicate_visible {:fg colors.text
                                                    :bg colors.surface}
                                :indicator_visible {:fg colors.text
                                                    :bg colors.surface}
                                :indicator_selected {:fg colors.sakura
                                                     :bg colors.surface}
                                :pick {:fg colors.text
                                       :bg colors.surface}
                                :pick_selected {:fg colors.text
                                                :bg colors.surface}
                                :pick_visible {:fg colors.text
                                               :bg colors.surface}
                                :offset_separator {:fg colors.surface-lightest
                                                   :bg colors.surface}
                                :trunc_marker {:fg colors.text :bg colors.surface}}})

(keymap :<leader>bn :<cmd>BufferLineCycleNext<cr> {:desc "Next Buffer"})
(keymap :<leader>bp :<cmd>BufferLineCyclePrev<cr> {:desc "Previous Buffer"})
(keymap :<leader>cr :<cmd>BufferLineCloseRight<cr>
        {:desc "Close Buffers To The Right"})
(keymap :<leader>cl :<cmd>BufferLineCloseLeft<cr>
        {:desc "Close Buffers To The Left"})
(keymap :<leader>co :<cmd>BufferLineCloseOthers<cr>
        {:desc "Close Other Buffers"})
(keymap :<leader>pb :<cmd>BufferLinePick<cr> {:desc "Pick Buffer"})
(keymap :<leader>pB :<cmd>BufferLinePickClose<cr>
        {:desc "Pick Buffer To Close"})

(keymap :<leader>1 "<cmd>BufferLineGoToBuffer 1<cr>" {:desc "Go To Buffer 1"})
(keymap :<leader>2 "<cmd>BufferLineGoToBuffer 2<cr>" {:desc "Go To Buffer 2"})
(keymap :<leader>3 "<cmd>BufferLineGoToBuffer 3<cr>" {:desc "Go To Buffer 3"})
(keymap :<leader>4 "<cmd>BufferLineGoToBuffer 4<cr>" {:desc "Go To Buffer 4"})
(keymap :<leader>5 "<cmd>BufferLineGoToBuffer 5<cr>" {:desc "Go To Buffer 5"})
(keymap :<leader>6 "<cmd>BufferLineGoToBuffer 6<cr>" {:desc "Go To Buffer 6"})
(keymap :<leader>7 "<cmd>BufferLineGoToBuffer 7<cr>" {:desc "Go To Buffer 7"})
(keymap :<leader>8 "<cmd>BufferLineGoToBuffer 8<cr>" {:desc "Go To Buffer 8"})
(keymap :<leader>9 "<cmd>BufferLineGoToBuffer 9<cr>" {:desc "Go To Buffer 9"})
(keymap :<leader>$ "<cmd>BufferLineGoToBuffer -1<cr>"
        {:desc "Go To Last Buffer"})
