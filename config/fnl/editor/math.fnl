(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/macro :editor.macros.export (export))

(fn clamp [value min max]
  (math.min max (math.max min value)))

(export clamp)
