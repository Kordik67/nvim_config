-----------------------------------------------------------
-- Replaces the UI for messages, cmdline and popmenu
-----------------------------------------------------------

-- Plugin: noice.nvim
-- url: https://github.com/folke/noice.nvim

local status_ok, noice = pcall(require, 'noice')
if not status_ok then
	return
end

noice.setup({
	lsp = {
		-- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_mardown"] = true,
			["cmp.entry.get_documentation"] = true;
		},
	},
	-- You can able a present for easier configuration
	presets = {
		bottom_search = true, -- Use a classic bottom cmdline for search
		command_palette = true, -- Position the cmdline and popmenu together
		long_message_to_split = true, -- Long messages will be sent to a split
		inc_rename = false, -- Enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- Add a border to hover docs and signature help
	},
	cmdline = {
      		format = {
        		cmdline = { icon = ">" },
        		search_down = { icon = "🔍⌄" },
        		search_up = { icon = "🔍⌃" },
        		filter = { icon = "$" },
        		lua = { icon = "☾" },
        		help = { icon = "?" },
      		},
    	},
})
