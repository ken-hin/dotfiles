-- render-markdown.nvim: pretty in-buffer rendering of markdown.
-- Headings, checkboxes, code blocks, tables, callouts, etc. The file on
-- disk is unchanged; this only changes how it looks while editing.
-- Toggle with `:RenderMarkdown toggle` if you ever want to see the raw text.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- LazyVim provides either nvim-web-devicons or mini.icons; either works.
  },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    paragraph = {
      -- Useful context to have when evaluating values.
      -- | text | text value of the node |

      -- Turn on / off paragraph rendering.
      enabled = true,
      -- Additional modes to render paragraphs.
      render_modes = false,
      -- Amount of margin to add to the left of paragraphs.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      -- Output is evaluated depending on the type.
      -- | function | `value(context)` |
      -- | number   | `value`          |
      left_margin = 0,
      -- Amount of padding to add to the first line of each paragraph.
      -- Output is evaluated using the same logic as 'left_margin'.
      indent = 0,
      -- Minimum width to use for paragraphs.
      min_width = 0,
    },
    code = {
      -- Turn on / off code block & inline code rendering.
      enabled = true,
      -- Additional modes to render code blocks.
      render_modes = false,
      -- Turn on / off sign column related rendering.
      sign = true,
      -- Whether to conceal nodes at the top and bottom of code blocks.
      conceal_delimiters = true,
      -- Turn on / off language heading related rendering.
      language = true,
      -- Determines where language icon is rendered.
      -- | center | center of code block |
      -- | right  | right of code block  |
      -- | left   | left of code block   |
      position = "left",
      -- Whether to include the language icon above code blocks.
      language_icon = true,
      -- Whether to include the language name above code blocks.
      language_name = true,
      -- Whether to include the language info above code blocks.
      language_info = true,
      -- Amount of padding to add around the language.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      language_pad = 0,
      -- A list of language names for which rendering will be disabled.
      disable = {},
      -- A list of language names for which background highlighting will be disabled.
      -- Likely because that language has background highlights itself.
      -- Use a boolean to make behavior apply to all languages.
      -- Borders above & below blocks will continue to be rendered.
      disable_background = { "diff" },
      -- Number of lines from start/end to skip rendering background.
      background_inset = 1,
      -- Width of the code block background.
      -- | block | width of the code block  |
      -- | full  | full width of the window |
      width = "full",
      -- Amount of margin to add to the left of code blocks.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      -- Margin available space is computed after accounting for padding.
      left_margin = 0,
      -- Amount of padding to add to the left of code blocks.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      left_pad = 0,
      -- Amount of padding to add to the right of code blocks when width is 'block'.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      right_pad = 0,
      -- Minimum width to use for code blocks when width is 'block'.
      min_width = 0,
      -- Determines how the top / bottom of code block are rendered.
      -- | none  | do not render a border                               |
      -- | thick | use the same highlight as the code body              |
      -- | thin  | when lines are empty overlay the above & below icons |
      -- | hide  | conceal lines unless language name or icon is added  |
      border = "hide",
      -- Used above code blocks to fill remaining space around language.
      language_border = "█",
      -- Added to the left of language.
      language_left = "",
      -- Added to the right of language.
      language_right = "",
      -- Used above code blocks for thin border.
      above = "▄",
      -- Used below code blocks for thin border.
      below = "▀",
      -- Turn on / off inline code related rendering.
      inline = true,
      -- Icon to add to the left of inline code.
      inline_left = "",
      -- Icon to add to the right of inline code.
      inline_right = "",
      -- Padding to add to the left & right of inline code.
      inline_pad = 0,
      -- Priority to assign to code background highlight.
      priority = 140,
      -- Highlight for code blocks.
      highlight = "RenderMarkdownCode",
      -- Highlight for code info section, after the language.
      highlight_info = "RenderMarkdownCodeInfo",
      -- Highlight for language, overrides icon provider value.
      highlight_language = nil,
      -- Highlight for border, use false to add no highlight.
      highlight_border = "RenderMarkdownCodeBorder",
      -- Highlight for language, used if icon provider does not have a value.
      highlight_fallback = "RenderMarkdownCodeFallback",
      -- Highlight for inline code.
      highlight_inline = "RenderMarkdownCodeInline",
      -- Highlight for inline code left icon, default to reverse of highlight_inline.
      highlight_inline_left = nil,
      -- Highlight for inline code right icon, default to reverse of highlight_inline.
      highlight_inline_right = nil,
      -- Determines how code blocks & inline code are rendered.
      -- | none     | { enabled = false }                           |
      -- | normal   | { language = false }                          |
      -- | language | { disable_background = true, inline = false } |
      -- | full     | uses all default values                       |
      style = "full",
    },
    heading = {
      -- Useful context to have when evaluating values.
      -- | level    | the number of '#' in the heading marker         |
      -- | sections | for each level how deeply nested the heading is |

      -- Turn on / off heading icon & background rendering.
      enabled = true,
      -- Additional modes to render headings.
      render_modes = false,
      -- Turn on / off atx heading rendering.
      atx = true,
      -- Turn on / off setext heading rendering.
      setext = true,
      -- Turn on / off sign column related rendering.
      sign = true,
      -- Replaces '#+' of 'atx_h._marker'.
      -- Output is evaluated depending on the type.
      -- | function | `value(context)`              |
      -- | string[] | `cycle(value, context.level)` |
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      -- Determines how icons fill the available space.
      -- | eol     | '#'s are concealed and icon is placed at right most column   |
      -- | right   | '#'s are concealed and icon is appended to right side        |
      -- | inline  | '#'s are concealed and icon is inlined on left side          |
      -- | overlay | icon is left padded with spaces and overlayed hiding all '#' |
      position = "overlay",
      -- Added to the sign column if enabled.
      -- Output is evaluated by `cycle(value, context.level)`.
      signs = { "󰫎 " },
      -- Width of the heading background.
      -- | block | width of the heading text |
      -- | full  | full width of the window  |
      -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
      width = "full",
      -- Amount of margin to add to the left of headings.
      -- Margin available space is computed after accounting for padding.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
      left_margin = 0,
      -- Amount of padding to add to the left of headings.
      -- Output is evaluated using the same logic as 'left_margin'.
      left_pad = 0,
      -- Amount of padding to add to the right of headings when width is 'block'.
      -- Output is evaluated using the same logic as 'left_margin'.
      right_pad = 0,
      -- Minimum width to use for headings when width is 'block'.
      -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
      min_width = 0,
      -- Determines if a border is added above and below headings.
      -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
      border = false,
      -- Always use virtual lines for heading borders instead of attempting to use empty lines.
      border_virtual = false,
      -- Highlight the start of the border using the foreground highlight.
      border_prefix = false,
      -- Used above heading for border.
      above = "▄",
      -- Used below heading for border.
      below = "▀",
      -- Highlight for the heading icon and extends through the entire line.
      -- Output is evaluated by `clamp(value, context.level)`.
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      -- Highlight for the heading and sign icons.
      -- Output is evaluated using the same logic as 'backgrounds'.
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
      -- Define custom heading patterns which allow you to override various properties based on
      -- the contents of a heading.
      -- The key is for healthcheck and to allow users to change its values, value type below.
      -- | pattern    | matched against the heading text @see :h lua-patterns |
      -- | icon       | optional override for the icon                        |
      -- | background | optional override for the background                  |
      -- | foreground | optional override for the foreground                  |
      custom = {},
    },
    pipe_table = {
      -- Turn on / off pipe table rendering.
      enabled = true,
      -- Additional modes to render pipe tables.
      render_modes = true,
      -- Pre configured settings largely for setting table border easier.
      -- | heavy  | use thicker border characters     |
      -- | double | use double line border characters |
      -- | round  | use round border corners          |
      -- | none   | does nothing                      |
      preset = "heavy",
      -- Determines how individual cells of a table are rendered.
      -- | overlay | writes completely over the table, removing conceal behavior and highlights |
      -- | raw     | replaces only the '|' characters in each row, leaving the cells unmodified |
      -- | padded  | raw + cells are padded to maximum visual width for each column             |
      -- | trimmed | padded except empty space is subtracted from visual width calculation      |
      cell = "padded",
      -- Fit wide tables to the current window by wrapping individual cells.
      wrap = false,
      -- Adjust the computed width of table cells using custom logic.
      cell_offset = function()
        return 0
      end,
      -- Amount of space to put between cell contents and border.
      padding = 0,
      -- Minimum column width to use for padded or trimmed cell.
      min_width = 0,
        -- Characters used to replace table border.
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal.
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
      -- Turn on / off top & bottom lines.
      border_enabled = true,
      -- Always use virtual lines for table borders instead of attempting to use empty lines.
      -- Will be automatically enabled if indentation module is enabled.
      border_virtual = true,
      -- Gets placed in delimiter row for each column, position is based on alignment.
      alignment_indicator = "━",
      -- Highlight for table heading, delimiter, and the line above.
      head = "RenderMarkdownTableHead",
      -- Highlight for everything else, main table rows and the line below.
      row = "RenderMarkdownTableRow",
      -- Determines how the table as a whole is rendered.
      -- | none   | { enabled = false }        |
      -- | normal | { border_enabled = false } |
      -- | full   | uses all default values    |
      style = "full",
    },
    bullet = {
      -- Useful context to have when evaluating values.
      -- | level | how deeply nested the list is, 1-indexed          |
      -- | index | how far down the item is at that level, 1-indexed |
      -- | value | text value of the marker node                     |

      -- Turn on / off list bullet rendering
      enabled = true,
      -- Additional modes to render list bullets
      render_modes = false,
      -- Replaces '-'|'+'|'*' of 'list_item'.
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
      -- Output is evaluated depending on the type.
      -- | function   | `value(context)`                                    |
      -- | string     | `value`                                             |
      -- | string[]   | `cycle(value, context.level)`                       |
      -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
      icons = { "●", "○", "◆", "◇" },
      -- Replaces 'n.'|'n)' of 'list_item'.
      -- Output is evaluated using the same logic as 'icons'.
      ordered_icons = function(ctx)
        local value = vim.trim(ctx.value)
        local index = tonumber(value:sub(1, #value - 1)) or 0
        return ("%d."):format(index > 1 and index or ctx.index)
      end,
      -- Padding to add to the left of bullet point.
      -- Output is evaluated depending on the type.
      -- | function | `value(context)` |
      -- | integer  | `value`          |
      left_pad = 0,
      -- Padding to add to the right of bullet point.
      -- Output is evaluated using the same logic as 'left_pad'.
      right_pad = 0,
      -- Highlight for the bullet icon.
      -- Output is evaluated using the same logic as 'icons'.
      highlight = "RenderMarkdownBullet",
      -- Highlight for item associated with the bullet point.
      -- Output is evaluated using the same logic as 'icons'.
      scope_highlight = {},
      -- Priority to assign to scope highlight.
      scope_priority = nil,
    },
    checkbox = {
      enabled = true,
    },
    indent = {
      -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
      -- level of the heading. Indenting starts from level 2 headings onward by default.

      -- Turn on / off org-indent-mode.
      enabled = true,
      -- Additional modes to render indents.
      render_modes = false,
      -- Amount of additional padding added for each heading level.
      per_level = 2,
      -- Heading levels <= this value will not be indented.
      -- Use 0 to begin indenting from the very first level.
      skip_level = 0,
      -- Do not indent heading titles, only the body.
      skip_heading = true,
      -- Prefix added when indenting, one per level.
      icon = "",
      -- Priority to assign to extmarks.
      priority = 0,
      -- Applied to icon.
      highlight = "RenderMarkdownIndent",
    },
  },
}
