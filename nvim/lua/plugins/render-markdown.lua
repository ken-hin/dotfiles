-- render-markdown.nvim: pretty in-buffer rendering of markdown.
-- Headings, checkboxes, code blocks, tables, callouts, etc. The file on
-- disk is unchanged; this only changes how it looks while editing.
-- Toggle with `:RenderMarkdown toggle` if you ever want to see the raw text.
--
-- Only settings that differ from the plugin's defaults are listed here.
-- Every option and its default: :h render-markdown, or the plugin's
-- lua/render-markdown/settings.lua.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- LazyVim provides either nvim-web-devicons or mini.icons; either works.
  },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    pipe_table = {
      preset = "heavy", -- thicker border characters
      padding = 0, -- no space between cell text and the border
      render_modes = true, -- keep tables drawn in every mode, even insert
      -- (table borders use virtual lines automatically because indent is on)
    },
    indent = {
      enabled = true, -- indent everything under a heading, like org-indent-mode
      skip_level = 0, -- start indenting from level-1 headings
      skip_heading = true, -- indent only the body, not the heading line itself
      icon = "", -- no bar in front of indented text
    },
  },
}
