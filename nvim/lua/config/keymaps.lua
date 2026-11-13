vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev buffer" })

-- Note: `jj` and `jk` -> Esc are handled by better-escape.nvim (see
-- lua/plugins/better-escape.lua). Doing it as a raw inoremap caused a
-- timeoutlen pause on every single `j`; better-escape only fires when the
-- second key arrives within 400 ms.

-- Explorer keymaps. `toggle = true` means the same keymap closes neo-tree
-- when it's already open. (You can also press `q` inside the tree to close.)
-- If neo-tree is open at one path and you press a different <leader>e* key,
-- it toggles closed — re-press to open at the new path.
vim.keymap.set("n", "<leader>ee", function()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end, { desc = "Explorer toggle (project root)" })

vim.keymap.set("n", "<leader>er", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("~") })
end, { desc = "Explorer toggle (home)" })

vim.keymap.set("n", "<leader>ef", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
end, { desc = "Explorer toggle (current file dir)" })
