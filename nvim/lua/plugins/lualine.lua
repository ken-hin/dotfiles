-- lualine: the statusline at the bottom of each window.
-- Starts from LazyVim's statusline (mode, branch, root dir, diagnostics,
-- git diff counts, position) and changes three things:
--   * file name with modified/readonly markers instead of LazyVim's path
--   * LSP breadcrumbs (Class > method > block) from nvim-navic
--   * a 12-hour clock with month/day
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
  },
  -- A function (instead of a plain table) so we edit LazyVim's sections
  -- rather than replace them and lose root dir + diagnostics.
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    opts.sections.lualine_c = {
      LazyVim.lualine.root_dir(),
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        "filename",
        file_status = true,
        path = 1, -- relative to cwd (with auto-cd on, that's usually just the name)
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
    }

    -- 12-hour time | month/day, e.g. "03:15 PM | 11/03"
    opts.sections.lualine_z = {
      { "datetime", style = "%I:%M %p | %m/%d" },
    }
  end,
}
