(import :editor.theme (highlight colors))
(import/lua :ibl :as indentblank-line)
(import/lua :ibl.hooks :as hooks)

(indentblank-line.setup
  {
  :indent {
  :char "┆"
  :highlight [
                        :IBLBase
                        :IBLSakura
                        :IBLMint
                        :IBLSky
                        :IBLPeach
                        :IBLBerry
                        ]}
  })
