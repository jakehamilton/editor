(import :editor.math (clamp))
(import/lua :nvim-treesitter.configs :as nvim-treesitter)

(fn hex-to-rgb [hex]
  (let [hex (hex:gsub "#" "")]
    (values (tonumber (hex:sub 1 2) 16) (tonumber (hex:sub 3 4) 16)
            (tonumber (hex:sub 5 6) 16))))

(fn rgb-to-hex [r g b]
  (string.format "#%02x%02x%02x" (math.floor (clamp r 0 255))
                 (math.floor (clamp g 0 255)) (math.floor (clamp b 0 255))))

(fn blend [color1 color2 ratio]
  (let [(r1 g1 b1) (hex-to-rgb color1)
        (r2 g2 b2) (hex-to-rgb color2)]
    (rgb-to-hex (+ r1 (* (- r2 r1) ratio)) (+ g1 (* (- g2 g1) ratio))
                (+ b1 (* (- b2 b1) ratio)))))

(fn lighten [color amount]
  (blend color "#ffffff" amount))

(fn darken [color amount]
  (blend color "#000000" amount))

(local colors {:surface "#1E1A24"
               :surface-light "#23202B"
               :surface-lighter "#282636"
               :surface-lightest "#2E2B3D"
               :surface-dark "#181520"
               :surface-darker "#14111B"
               :text "#EEEAF1"
               :text-dark "#827889"
               :sakura-light "#F6B7D1"
               :sakura "#E598B8"
               :sakura-dark "#C47793"
               :leaf-light "#BBEAC4"
               :leaf "#9AD0A5"
               :leaf-dark "#7CAC87"
               :berry-light "#E8BADA"
               :berry "#CE98BD"
               :berry-dark "#A67396"
               :mint-light "#B4EFE3"
               :mint "#91D5C7"
               :mint-dark "#77B0A4"
               :peach-light "#F4C8BD"
               :peach "#E8B0A0"
               :peach-dark "#C79285"
               :sky-light "#D1E4F3"
               :sky "#A8C9E7"
               :sky-dark "#88B0D8"
               :white "#FFFFFF"
               :black "#000000"
               :none :NONE})

(local highlights
       {:Normal {:fg colors.text :bg colors.surface}
        :NormalNC {:fg colors.text :bg colors.surface}
        :NormalSB {:fg colors.text :bg colors.surface-darker}
        :StatusLine {:fg colors.text :bg colors.surface-darker}
        :LineNr {:fg colors.text}
        :LineNrAbove {:fg colors.text-dark}
        :LineNrBelow {:fg colors.text-dark}
        :CursorLineNr {:fg colors.text :bg colors.surface-light}
        :CursorLine {:bg colors.surface-light}
        :EndOfBuffer {:fg colors.surface-lightest :bg colors.surface}
        :StatusLine {:fg colors.text :bg colors.surface-darker}
        :StatusLineNC {:fg colors.text.lightest :bg colors.surface}
        :WinSeparator {:fg colors.surface-lightest}
        :Comment {:fg colors.text-dark :italic true}
        "@comment" {:fg colors.text-dark :italic true}
        :String {:fg colors.mint}
        "@string" {:fg colors.mint}
        :Character {:fg colors.text}
        :Number {:fg colors.peach}
        :Boolean {:fg colors.text}
        :Float {:fg colors.text :bg colors.surface-light}
        :Title {:fg colors.text :bold true}
        :Keyword {:fg colors.sakura}
        "@keyword" {:fg colors.sakura}
        :Conditional {:fg colors.text}
        :Repeat {:fg colors.text}
        :Label {:fg colors.text}
        :Operator {:fg colors.sakura}
        "@operator" {:fg colors.sakura}
        "@punctuation.bracket" {:fg colors.text}
        "@punctuation.delimiter" {:fg colors.text}
        :Exception {:fg colors.text}
        :Function {:fg colors.sakura-light}
        "@function" {:fg colors.sakura-light}
        :Identifier {:fg colors.sakura-light}
        :Parameter {:fg colors.text}
        "@parameter" {:fg colors.text}
        :Constant {:fg colors.berry}
        :Variable {:fg colors.text}
        "@variable" {:fg colors.text}
        :Type {:fg colors.text}
        "@type" {:fg colors.text}
        :StorageClass {:fg colors.berry-light}
        :Structure {:fg colors.berry-light}
        :Typedef {:fg colors.text}
        :PreProc {:fg colors.text}
        :Include {:fg colors.mint}
        :Define {:fg colors.text-dark}
        :Macro {:fg colors.sakura}
        :Special {:fg colors.sakura}
        :SpecialChar {:fg colors.sakura}
        :Tag {:fg colors.text}
        :Delimiter {:fg colors.text}
        :SpecialComment {:fg colors.text-dark :italic true}
        :Debug {:fg colors.text}
        :Underlined {:underline true}
        :Italic {:italic true}
        :Bold {:bold true}
        :Error {:fg colors.text :bg colors.text}
        :Todo {:fg colors.text :bg colors.sakura-dark :bold true}
        :SpellCap {:fg colors.mint}
        :Directory {:fg colors.sakura}
        "@markup.link.vimdoc" {:fg colors.sakura :underline true}
        :MoreMsg {:fg colors.mint}
        :ModeMsg {:fg colors.sakura}
        :ErrorMsg {:fg colors.text}
        :Question {:fg colors.text}
        :WarningMsg {:fg colors.peach}
        :Changed {:fg colors.mint}
        :Search {:fg colors.sakura :bg colors.surface-lightest}
        :MsgArea {:fg colors.text :bg colors.surface-light}
        :NormalFloat {:fg colors.text :bg colors.surface}
        :FloatTitle {:bold true}
        :FloatBorder {:fg colors.surface-lightest}
        :DiagnosticVirtualTextInfo {:fg colors.text-dark}
        :DiagnosticError {:fg colors.sakura}
        :DiagnosticWarn {:fg colors.peach}
        :DiagnosticInfo {:fg colors.text}
        :DiagnosticHint {:fg colors.text}
        :DiagnosticOk {:fg colors.mint}
        :DiffAdd {:fg colors.mint-dark :bg colors.mint-light}
        :DiffChange {:fg colors.peach-dark :bg colors.peach-light}
        ; nvim-notify
        :NotifyERRORBorder {:fg colors.berry}
        :NotifyERRORIcon {:fg colors.berry}
        :NotifyERRORTitle {:fg colors.berry}
        :NotifyERRORBody {:fg colors.berry}
        :NotifyWARNBorder {:fg colors.peach}
        :NotifyWARNIcon {:fg colors.peach}
        :NotifyWARNTitle {:fg colors.peach}
        :NotifyWARNBody {:fg colors.peach}
        :NotifyINFOBorder {:fg colors.sakura}
        :NotifyINFOIcon {:fg colors.sakura}
        :NotifyINFOTitle {:fg colors.sakura}
        :NotifyINFOBody {:fg colors.sakura}
        :NotifyDEBUGBorder {:fg colors.text-dark}
        :NotifyDEBUGIcon {:fg colors.text-dark}
        :NotifyDEBUGTitle {:fg colors.text-dark}
        :NotifyDEBUGBody {:fg colors.text-dark}
        :NotifyTRACEBorder {:fg colors.text-dark}
        :NotifyTRACEIcon {:fg colors.text-dark}
        :NotifyTRACETitle {:fg colors.text-dark}
        :NotifyTRACEBody {:fg colors.text-dark}
        :NotifyLogTitle {:fg colors.text :bold true}
        ; Noice
        :NoiceCmdlinePopup {:fg colors.text :bg colors.surface}
        :NoiceCmdlinePopupBorder {:fg colors.sakura :bg colors.surface}
        :NoiceCmdlinePrompt {:fg colors.text-dark}
        :NoiceCmdlineIcon {:fg colors.sakura}
        :NoiceSplitBorder {:fg colors.surface-lightest
                           :bg colors.surface-lightest}
        :NoiceLspProgressSpinner {:fg colors.mint :bg colors.surface}
        :NoiceLspProgressTitle {:fg colors.text-dark :bg colors.surface}
        :NoiceLspProgressClient {:fg colors.sakura :bg colors.surface}
        ; Which-Key
        :WhichKey {:fg colors.sakura}
        :WhichKeyDesc {:fg colors.mint}
        :WhichKeyGroup {:fg colors.sakura-light}
        :WhichKeyTitle {:fg colors.text :bold true}
        :WhichKeyNormal {:fg colors.text :bg colors.surface-lighter}
        :WhichKeyIconAzure {:fg colors.mint}
        :WhichKeyIconBlue {:fg colors.mint}
        :WhichKeyIconCyan {:fg colors.mint}
        :WhichKeyIconGreen {:fg colors.mint}
        :WhichKeyIconGrey {:fg colors.mint}
        :WhichKeyIconOrange {:fg colors.mint}
        :WhichKeyIconPurple {:fg colors.mint}
        :WhichKeyIconRed {:fg colors.mint}
        :WhichKeyIconYellow {:fg colors.mint}
        ; nvim-tree
        :NvimTreeNormal {:fg colors.text :bg colors.surface}
        :NvimTreeExecFile {:fg colors.sakura}
        :NvimTreeImageFile {:fg colors.text}
        :NvimTreeSpecialFile {:fg colors.text}
        :NvimTreeSymlink {:fg colors.mint}
        :NvimTreeFolderIcon {:fg colors.sakura}
        :NvimTreeFolderName {:fg colors.text}
        :NvimTreeFolderSymlink {:fg colors.mint}
        :NvimTreeEmptyFolderName {:fg colors.text-dark}
        :NvimTreeOpenedFolderName {:fg colors.text}
        :NvimTreeOpenedFolderIcon {:fg colors.sakura}
        :NvimTreeSymlinkFolderName {:fg colors.text}
        :NvimTreeFileIcon {:fg colors.sakura}
        :NvimTreeSymlinkIcon {:fg colors.mint}
        :NvimTreeGitIgnored {:fg colors.text-dark}
        :NvimTreeGitIgnoredIcon {:fg colors.text-dark}
        :NvimTreeGitStaged {:fg colors.mint}
        :NvimTreeGitStagedIcon {:fg colors.mint}
        :NvimTreeModified {:fg colors.sakura}
        :NvimTreeModifiedIcon {:fg colors.sakura}
        :NvimTreeGitDeleted {:fg colors.sakura}
        :NvimTreeGitDeletedIcon {:fg colors.sakura}
        :NvimTreeGitDirty {:fg colors.peach}
        :NvimTreeGitDirtyIcon {:fg colors.peach}
        :NvimTreeGitNew {:fg colors.mint}
        :NvimTreeGitNewIcon {:fg colors.mint}
        :NvimTreeGitMerge {:fg colors.peach}
        :NvimTreeGitMergeIcon {:fg colors.peach}
        ; mini.icons
        :MiniIconsAzure {:fg colors.sky}
        :MiniIconsBlue {:fg colors.sky}
        :MiniIconsCyan {:fg colors.mint}
        :MiniIconsGreen {:fg colors.mint}
        :MiniIconsGrey {:fg colors.text-dark}
        :MiniIconsOrange {:fg colors.peach}
        :MiniIconsPurple {:fg colors.berry}
        :MiniIconsRed {:fg colors.sakura}
        :MiniIconsYellow {:fg colors.peach}
        ; GitSigns
        :GitSignsAdd {:fg colors.mint}
        :GitSignsChange {:fg colors.peach}
        :GitSignsDelete {:fg colors.sakura}
        :GitSignsUntracked {:fg colors.text-dark}
        ; rainbow-delimiters.nvim
        :RainbowDelimiterText {:fg colors.text}
        :RainbowDelimiterSakura {:fg colors.sakura}
        :RainbowDelimiterPeach {:fg colors.peach}
        :RainbowDelimiterBerry {:fg colors.berry}
        :RainbowDelimiterMint {:fg colors.mint}
        :RainbowDelimiterSky {:fg colors.sky}
        ; indent-blank-line
        :IBLBase {:fg colors.text}
        :IBLSakura {:fg colors.sakura}
        :IBLPeach {:fg colors.peach}
        :IBLBerry {:fg colors.berry}
        :IBLMint {:fg colors.mint}
        :IBLSky {:fg colors.sky}
        ; Nix
        :nixArgumentEllipsis {:fg colors.text-dark}
        ; TypeScript
        :typescriptArrowFunc {:fg colors.text}
        :typescriptDocRef {:fg colors.sakura :underline true}
        "@keyword.directive.typescript" {:fg colors.mint}})

(fn highlight [name color]
  (when (= nil color.fg) (tset color :fg colors.none))
  (when (= nil color.bg) (tset color :bg colors.none))
  (vim.api.nvim_set_hl 0 name color))

(fn setup []
  (nvim-treesitter.setup {:auto_install false
                          :ignore_install :all
                          :highlight {:enable true}})
  (vim.cmd "highlight clear")
  (vim-global :colors_name :bliss)
  (vim-option :termguicolors true)
  (each [name color (pairs highlights)]
    (highlight name color))
  (vim.diagnostic.config {:signs {:text {vim.diagnostic.severity.ERROR ""
                                         vim.diagnostic.severity.WARN ""
                                         vim.diagnostic.severity.HINT ""
                                         vim.diagnostic.severity.INFO ""}}}))

(set _G.colors colors)

(export colors setup highlight)
