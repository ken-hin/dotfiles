-- better-escape.nvim: smarter `jj` (and friends) for escaping insert mode.
-- Unlike a raw `inoremap jj <Esc>`, this only fires when both keys are pressed
-- within `timeout` ms. Single `j` doesn't pause for timeoutlen, and you can
-- type real words containing `j` at full speed.
return {
  "max397574/better-escape.nvim",
  event = "InsertCharPre",
  opts = {
    timeout = 400, -- ms window for the second key
    default_mappings = false, -- only enable what we explicitly map below
    mappings = {
      i = {
        j = {
          k = "<Esc>", -- jk -> Esc
          j = "<Esc>", -- jj -> Esc
        },
      },
    },
  },
}
