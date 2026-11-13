return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Icons: LazyVim ships mini.icons (or nvim-web-devicons). Neo-tree picks
    -- up whichever is available automatically.
  },
  keys = {
    -- Disable LazyVim's default explorer keymaps so ours in lua/config/keymaps.lua own these.
    { "<leader>e", false },
    { "<leader>E", false },
    { "<leader>fe", false },
    { "<leader>fE", false },
  },
  opts = {
    -- Show all sources as tabs in a top "winbar" inside the sidebar.
    -- Switch between them with `<Tab>` (next) and `<` (previous).
    sources = { "filesystem", "buffers", "git_status" },
    source_selector = {
      winbar = true,
      statusline = false,
      content_layout = "center",
      sources = {
        { source = "filesystem", display_name = "  Files " },
        { source = "buffers", display_name = "  Bufs " },
        { source = "git_status", display_name = "  Git " },
      },
    },
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    enable_modified_markers = true,
    enable_opened_markers = true,
    popup_border_style = "rounded",

    event_handlers = {
      -- Mirror your existing behavior: cd Vim to the explorer's path on entry,
      -- and force line numbers on (neo-tree disables them by default for its
      -- own buffers; this overrides that).
      {
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true

          local state = require("neo-tree.sources.manager").get_state("filesystem")
          if state and state.path then
            vim.cmd.cd(state.path)
          end
        end,
      },
      -- LSP-aware rename/move (updating imports in other files) comes from
      -- LazyVim's neo-tree extra, which adds its own handlers in config(),
      -- so it isn't repeated here.
    },

    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
        default = "",
      },
      modified = {
        symbol = "",
        highlight = "NeoTreeModified",
      },
      git_status = {
        symbols = {
          -- Change type
          added = "✚",
          deleted = "✖",
          modified = "",
          renamed = "󰁕",
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
      -- Inline columns. `required_width` makes them auto-hide when the
      -- sidebar is narrower than the threshold, keeping things tidy.
      -- With default width=50: file_size is visible, last_modified hides
      -- until you widen the sidebar (e.g. <C-w>> or :vertical resize 80).
      file_size = {
        enabled = true,
        required_width = 30,
      },
      type = {
        enabled = true,
      },
      last_modified = {
        enabled = true,
        required_width = 50,
        format = "%m/%d %H:%M",
      },
      created = {
        enabled = false,
      },
      symlink_target = {
        enabled = false,
      },
    },

    -- Re-route delete through the system Trash via the `trash` CLI
    -- (install on macOS with: brew install trash).
    commands = {
      delete = function(state)
        local node = state.tree:get_node()
        if node.type == "message" then
          return
        end
        local path = node.path
        local name = node.name or vim.fn.fnamemodify(path, ":t")
        require("neo-tree.ui.inputs").confirm(string.format("Trash '%s'?", name), function(confirmed)
          if not confirmed then
            return
          end
          if vim.fn.executable("trash") == 0 then
            vim.notify(
              "`trash` CLI not found. Install with `brew install trash` to enable trash support.",
              vim.log.levels.ERROR,
              { title = "neo-tree" }
            )
            return
          end
          local result = vim.fn.system({ "trash", path })
          if vim.v.shell_error ~= 0 then
            vim.notify("Trash failed: " .. result, vim.log.levels.ERROR, { title = "neo-tree" })
            return
          end
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end,
      delete_visual = function(state, selected_nodes)
        if vim.fn.executable("trash") == 0 then
          vim.notify(
            "`trash` CLI not found. Install with `brew install trash` to enable trash support.",
            vim.log.levels.ERROR,
            { title = "neo-tree" }
          )
          return
        end
        require("neo-tree.ui.inputs").confirm(string.format("Trash %d items?", #selected_nodes), function(confirmed)
          if not confirmed then
            return
          end
          for _, node in ipairs(selected_nodes) do
            vim.fn.system({ "trash", node.path })
          end
          require("neo-tree.sources.manager").refresh(state.name)
        end)
      end,
    },

    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = true,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default", -- :e <dir> opens in neo-tree
      window = {
        mappings = {
          -- Filesystem-only commands. Putting these on the top-level
          -- window.mappings causes "Invalid mapping" warnings because the
          -- buffers and git_status sources don't have these commands.
          ["."] = "set_root",
          ["<BS>"] = "navigate_up",
          ["f"] = "filter_on_submit",
          ["<C-x>"] = "clear_filter",
        },
      },
    },

    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      show_unloaded = true,
    },

    git_status = {
      window = {
        position = "float",
      },
    },

    window = {
      position = "left",
      width = 40,
      mappings = {
        ["<space>"] = false, -- unmap so <leader> works
        ["l"] = "open",
        ["h"] = "close_node",
        -- snacks-Explorer-flavored mutation keys
        ["a"] = { "add", config = { show_path = "relative" } },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        -- preview pane
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
        -- source switching
        ["<"] = "prev_source",
        ["<tab>"] = "next_source",
      },
    },
  },
}
