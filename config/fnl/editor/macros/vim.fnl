;; fennel-ls: macro-file

(fn vim-option [name ?value]
  "Set a value in `vim.opt`.

```fennel
(vim-option :mouse :a)
(vim-option :numberwidth 6)
(vim-option :signcolumn \"yes:1\")
```
  "
  (if (= nil ?value)
      `(. vim.opt ,(tostring name))
      `(set (. vim.opt ,(tostring name)) ,?value)))

(fn vim-global [name ?value]
  "Set a value in `vim.g`.

```fennel
(vim-global :mapleader \" \")
(vim-global :maplocalleader \",\")
(vim-global :colors_name :bliss)
```
  "
  (if (= nil ?value)
      `(. vim.g ,(tostring name))
      `(set (. vim.g ,(tostring name)) ,?value)))

{: vim-option : vim-global}
