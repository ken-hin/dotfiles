return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "SmiteshP/nvim-navic",
      opts = {
        separator = "  ",
        highlight = true,
        depth_limit = 5,
        -- Auto-attach to any LSP that exposes documentSymbolProvider so
        -- breadcrumbs populate without us writing an LspAttach autocmd.
        lsp = { auto_attach = true },
      },
    },
    "onsails/lspkind-nvim",
  },
  opts = {
    sections = {
      lualine_c = {
        {
          "filename",
          file_status = true,
          path = 1,
          symbols = {
            modified = "[+]", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for newly created file before first write
          },
        },
        {
          "navic",
          cond = function()
            return require("nvim-navic").is_available()
          end,
        },
      },
      lualine_z = {
        { "datetime", style = "%I:%M %p | %m/%y" },
      },
    },
    -- Active winbar: filetype icon + filename + LSP-symbol breadcrumbs.
    -- Breadcrumbs (Class > method > if-block) come from nvim-navic and
    -- show where the cursor is inside the file's symbol tree.
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
