(import :editor.theme (colors highlight))
(import/lua :lualine)

(fn empty []
	"")

(lualine.setup
	{
	:options {
		:globalstatus true
		:disabled_filetypes {
			:statusline [:dashboard :NvimTree :Trouble :TelescopePrompt]
			:tabline [:dashboard :NvimTree :Trouble :TelescopePrompt]
			:winbar [:dashboard :NvimTree :Trouble :TelescopePrompt]
		}
		:ignore_focus [:dashboard :NvimTree :Trouble :TelescopePrompt]
		:component_separators {
			:left "⋮"
			:right "⋮"
		}

		:section_separators {
			:left ""
			:right ""
		}

		:theme {
			:normal {
				:a {:fg colors.surface-dark :bg colors.text}
				:b {:bg colors.surface-lighter}
				:c {:bg colors.surface-darkest}
				:x {:bg colors.surface-darkest}
				:y {:bg colors.surface-lighter}
				:z {:fg colors.surface-dark :bg colors.text}
			}
			:insert {
				:a {:fg colors.text :bg colors.sakura}
				:b {:bg colors.surface-lighter}
				:c {:bg colors.surface-darkest}
				:x {:bg colors.surface-darkest}
				:y {:bg colors.surface-lighter}
				:z {:fg colors.text :bg colors.sakura}
			}
			:visual {
				:a {:fg colors.text :bg colors.peach}
				:b {:bg colors.surface-lighter}
				:c {:bg colors.surface-darkest}
				:x {:bg colors.surface-darkest}
				:y {:bg colors.surface-lighter}
				:z {:fg colors.text :bg colors.peach}
			}
			:replace {
				:a {:fg colors.text :bg colors.mint}
				:b {:bg colors.surface-lighter}
				:c {:bg colors.surface-darkest}
				:x {:bg colors.surface-darkest}
				:y {:bg colors.surface-lighter}
				:z {:fg colors.text :bg colors.mint}
			}
			:inactive {
				:a {:fg colors.surface-dark :bg colors.text}
				:b {:bg colors.surface-lighter}
				:c {:bg colors.surface-darkest}
				:x {:bg colors.surface-darkest}
				:y {:bg colors.surface-lighter}
				:z {:fg colors.surface-dark :bg colors.text}
			}
		}
	}
	:sections {
		:lualine_a [ (lambda [] "") ]
		:lualine_b [
								(doto [:branch]
									(tset :icon ""))
								:diff
								]
		:lualine_c [ ]
		:lualine_x [
								(doto [:diagnostics]
									(tset :update_in_insert true))
								]
		:lualine_y [
								:encoding
								:filetype
								]
		:lualine_z [
								:location
								:progress
								(doto [:fileformat]
									(tset :icon_only true))
								]
	}})
