-- nvim-spider: makes w/e/b respect camelCase and snake_case as word boundaries.
-- For example, `w` on `someLongVariableName` jumps to L, V, N instead of past
-- the whole identifier. Works in normal, operator-pending, and visual modes,
-- so things like `daw`, `ciw`, `vw` all use the new word boundaries.
return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "w",
      function()
        require("spider").motion("w")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider-w (sub-word forward)",
    },
    {
      "e",
      function()
        require("spider").motion("e")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider-e (sub-word end)",
    },
    {
      "b",
      function()
        require("spider").motion("b")
      end,
      mode = { "n", "o", "x" },
      desc = "Spider-b (sub-word back)",
    },
  },
  opts = {
    skipInsignificantPunctuation = true,
  },
  config = function(_, opts)
    require("spider").setup(opts)
  end,
}
