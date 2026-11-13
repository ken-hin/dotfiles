return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = false },
    picker = {
      sources = {
        explorer = { enabled = false },
      },
    },
  },
  -- Disable LazyVim's snacks Explorer keymaps so they don't race with our
  -- neo-tree <leader>e* mappings. With these gone, <leader>e is purely a
  -- which-key prefix and only our ee/er/ef bindings fire.
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    { "<leader>fe", false },
    { "<leader>fE", false },
    -- Swap <leader>ff and <leader>fF: cwd is the no-shift default since
    -- it's the more common search target. Project root requires shift.
    {
      "<leader>ff",
      LazyVim.pick("files", { root = false }),
      desc = "Find Files (cwd)",
    },
    {
      "<leader>fF",
      LazyVim.pick("files"),
      desc = "Find Files (Root Dir)",
    },
  },
}
