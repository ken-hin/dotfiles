-- nvim-treesitter-context: sticky header at the top of the buffer showing the
-- enclosing function/class/block when you scroll into a long body. Helps you
-- not lose track of where you are in deep code.
-- Toggle with <leader>uC if it ever feels distracting.
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  opts = {
    enable = true,
    max_lines = 3, -- cap the sticky header at 3 lines so it doesn't eat the screen
    min_window_height = 20, -- skip on small splits
    multiline_threshold = 1,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
  },
  keys = {
    {
      "<leader>uC",
      function()
        require("treesitter-context").toggle()
      end,
      desc = "Toggle treesitter context",
    },
  },
}
