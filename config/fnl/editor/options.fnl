; Leader
(vim-global :mapleader " ")
(vim-global :maplocalleader ",")

; Disable mouse
(vim-option :mouse "")

; Line numbers
(vim-option :number true)
(vim-option :relativenumber true)
(vim-option :numberwidth 6)

; Cursor line
(vim-option :cursorline false)
(vim-option :cursorlineopt :line)

; Signs
(vim-option :signcolumn "yes:1")

; Text wrapping
(vim-option :wrap true)
(vim-option :linebreak true)

; Scrolling
(vim-option :scrolloff 4)

; Status line
(vim-option :laststatus 3)

; Splits
(vim-option :splitbelow true)
(vim-option :splitright true)

; State
(vim-option :swapfile false)
(vim-option :backup false)
(vim-option :undofile true)

; Indentation
(vim-option :tabstop 2)
(vim-option :shiftwidth 2)
(vim-option :expandtab true)
(vim-option :smarttab true)

; Folds
(vim-option :foldenable true)
(vim-option :foldcolumn :0)
(vim-option :foldlevel 99)
(vim-option :foldlevelstart 99)
