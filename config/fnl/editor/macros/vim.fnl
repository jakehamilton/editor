(fn vim-option [name ?value]
  (if (= nil ?value)
      `(. vim.opt ,(tostring name))
      `(set (. vim.opt ,(tostring name)) ,?value)))

(fn vim-global [name ?value]
  (if (= nil ?value)
      `(. vim.g ,(tostring name))
      `(set (. vim.g ,(tostring name)) ,?value)))

{: vim-option : vim-global}
