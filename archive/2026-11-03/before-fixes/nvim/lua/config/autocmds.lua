vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto_cd", { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
      vim.cmd("lcd " .. dir)
    end
  end,
})

-- NOTE: Previously had a FileType=neo-tree autocmd that re-bound <leader> to
-- which-key in loop mode. That was a workaround for an old neo-tree config
-- where <space> was mapped to a tree action. Our current neo-tree config has
-- ["<space>"] = false in window.mappings, so <leader> propagates to global
-- which-key naturally — no autocmd needed. The loop=true also caused a
-- recursion crash, so leaving it removed.
