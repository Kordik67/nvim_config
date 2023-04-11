-----------------------------------------------------------
-- Autocomplete configuration file
-----------------------------------------------------------

-- Plugin: nvim-cmp
-- url: https://github.com/hrsh7th/nvim-cmp


local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

local luasnip_status_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_status_ok then
  return
end

local ts_status_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
if not ts_status_ok then
	return
end

cmp.setup {
  -- Load snippet support
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

-- Completion settings
  completion = {
    --completeopt = 'menu,menuone,noselect'
    keyword_length = 2
  },

  -- Key mapping
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    -- Tab mapping
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end
  },

  -- Load sources, see: https://github.com/topics/nvim-cmp
  sources = {
    { name = 'nvim_lsp' },
    entry_filter = function(entry, context)
	    local kind = entry:get_kind()
	    local node = ts_utils.get_node_at_cursor():type()

	    if node == "arguments" then
		    if kind == 6 then
			    return true
		    else
			    return false
		    end
	    end

	    return true
    end,
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'vsnip' },
  },

  formatting = {
	  fields = { "abbr", "kind", "menu" },
	  format = function(entry,vim_item)
		  local kind = vim_item.kind
		  --vim_item.kind = " " .. (icons[kind] or "?") .. " "
		  
		  local source = entry.source.name
		  vim_item.menu = "(" .. source .. ")"

		  if source == "vsnip" or source == "nvim_lsp" then
			  vim_item.dup = 0
		  end

		  vim_item.abbr = vim_item.abbr:match("[^(]+")

		  return vim_item
	  end,
  }
}

