-- Harpoon2: per-project file bookmarks with fast slot-based switching.
-- <leader>ha   add current file to harpoon list
-- <leader>hh   open the harpoon menu (you can edit it like a buffer)
-- <C-1..4>     jump directly to slot 1-4
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local harpoon = require("harpoon")
    return {
      {
        "<leader>ha",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon: add file",
      },
      {
        "<leader>hh",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon: menu",
      },
      {
        "<leader>hp",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon: prev",
      },
      {
        "<leader>hn",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon: next",
      },
      {
        "<C-1>",
        function()
          harpoon:list():select(1)
        end,
        desc = "Harpoon: file 1",
      },
      {
        "<C-2>",
        function()
          harpoon:list():select(2)
        end,
        desc = "Harpoon: file 2",
      },
      {
        "<C-3>",
        function()
          harpoon:list():select(3)
        end,
        desc = "Harpoon: file 3",
      },
      {
        "<C-4>",
        function()
          harpoon:list():select(4)
        end,
        desc = "Harpoon: file 4",
      },
    }
  end,
  config = function()
    require("harpoon"):setup()
  end,
}
