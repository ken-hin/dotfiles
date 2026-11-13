-- Auto-cd: every time you enter a normal file buffer, set this window's cwd
-- (:lcd) to that file's folder. Terminals, :! commands and the "cwd" pickers
-- (<leader>fF, <leader>sG, <leader>fT) then start where the file lives.
-- Project-wide pickers (<leader>ff, <leader><space>, <leader>/) use the
-- project root instead, so they still search the whole project.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto_cd", { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end
    local name = vim.api.nvim_buf_get_name(event.buf)
    if name == "" then
      return
    end
    local dir = vim.fn.fnamemodify(name, ":p:h")
    -- Skip files whose folder doesn't exist yet (e.g. :e new/dir/file.lua).
    if vim.fn.isdirectory(dir) == 0 then
      return
    end
    -- fnameescape keeps folders with spaces ("Application Support") working.
    vim.cmd("lcd " .. vim.fn.fnameescape(dir))
  end,
})

-- NOTE: Previously had a FileType=neo-tree autocmd that re-bound <leader> to
-- which-key in loop mode. That was a workaround for an old neo-tree config
-- where <space> was mapped to a tree action. Our current neo-tree config has
-- ["<space>"] = false in window.mappings, so <leader> propagates to global
-- which-key naturally — no autocmd needed. The loop=true also caused a
-- recursion crash, so leaving it removed.
