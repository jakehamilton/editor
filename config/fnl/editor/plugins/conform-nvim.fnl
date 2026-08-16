(import-macros {: import : import/macro : import/lua} :editor.macros.import)

(import/lua :conform)

(conform.setup {:formatters_by_ft {:fennel [:fnlfmt]}})
