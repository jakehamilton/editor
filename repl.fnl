; Run this file using:
; fennel --load repl.fnl
;
; Load macros in the Repl starting with:
; (import-macros {: import : import/macro : import/lua} :editor.macros.import)
; (import-macros {: export} :editor.macros.export)
;
; Unfortunately we can't automatically load these macros
; in this file due to how Fennel's Repl environment works.

(local fennel (require :fennel))

;; Set up paths
(set fennel.path (.. fennel.path ";./config/fnl/?.fnl;./config/fnl/?/init.fnl"))
(set fennel.macro-path (.. fennel.macro-path ";./config/fnl/?.fnl;./config/fnl/?/init.fnl"))

;; Add Fennel's searcher
(fennel.install)

(print "Editor modules loaded!")
