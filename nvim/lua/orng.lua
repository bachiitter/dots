-------------------------------------------------------------------------------
-- orng.nvim - Neovim colorscheme
-- Ported from Zed "orng" theme by Matt Silverlock / Cloudflare
-------------------------------------------------------------------------------
--
-- USAGE:
--   require('orng').setup({
--     style = 'dark',        -- 'dark' or 'light'
--     transparent = false,   -- true for transparent background
--   })
--
-- OPTIONS:
--   style       : string  - 'dark' (default) or 'light'
--   transparent : boolean - Enable transparent background (default: false)
--   colors      : table   - Override palette colors
--   highlights  : table   - Override highlight groups
--
-- EXAMPLES:
--   -- Basic dark theme
--   require('orng').setup({ style = 'dark' })
--
--   -- Transparent background
--   require('orng').setup({ style = 'dark', transparent = true })
--
--   -- Custom colors
--   require('orng').setup({
--     style = 'dark',
--     colors = {
--       accent = '#ff0000',
--       string = '#00ff00',
--     },
--   })
--
--   -- Custom highlights
--   require('orng').setup({
--     style = 'dark',
--     highlights = {
--       Comment = { fg = '#555555', italic = false },
--     },
--   })
--
-- COMMANDS:
--   :OrngDark  - Switch to dark theme
--   :OrngLight - Switch to light theme
--
-- COLOR PALETTE (dark):
--   bg, bg_dark, bg_highlight, bg_visual
--   fg, fg_muted, fg_dark
--   accent (#EC5B2B), accent_alt (#EE7948)
--   keyword, func, string, number, boolean, constant
--   variable, variable_special, type, property, operator
--   comment, tag, attribute, enum
--   error, warning, info, hint, success
--   git_add, git_change, git_delete
--
-------------------------------------------------------------------------------

local M = {}

local colors = {
  -- Dark theme colors (from Zed orng theme)
  dark = {
    bg = "#161a22",
    bg_dark = "#10131a",
    bg_highlight = "#1e232b",
    bg_visual = "#2d343f",
    fg = "#eeeeee",
    fg_muted = "#808080",
    fg_dark = "#606060",
    border = "#3c3c3c",
    accent = "#EC5B2B",
    accent_alt = "#EE7948",

    -- Syntax
    keyword = "#EC5B2B",
    func = "#EE7948",
    string = "#6ba1e6",
    number = "#FFF7F1",
    boolean = "#FFF7F1",
    constant = "#FFF7F1",
    variable = "#e06c75",
    variable_special = "#EE7948",
    type = "#e5c07b",
    property = "#679cd9",
    operator = "#56b6c2",
    comment = "#808080",
    tag = "#EC5B2B",
    attribute = "#EE7948",
    enum = "#e06c75",

    -- Diagnostic
    error = "#e06c75",
    warning = "#EC5B2B",
    info = "#56b6c2",
    hint = "#808080",
    success = "#7fd88f",

    -- Git
    git_add = "#6ba1e6",
    git_change = "#e5c07b",
    git_delete = "#e06c75",

    -- Terminal
    term_black = "#161a22",
    term_red = "#e06c75",
    term_green = "#7fd88f",
    term_yellow = "#e5c07b",
    term_blue = "#56b6c2",
    term_magenta = "#EE7948",
    term_cyan = "#56b6c2",
    term_white = "#eeeeee",
  },
  -- Light theme colors
  light = {
    bg = "#ffffff",
    bg_dark = "#FFF7F1",
    bg_highlight = "#f5f0eb",
    bg_visual = "#e1e1e1",
    fg = "#1a1a1a",
    fg_muted = "#8a8a8a",
    fg_dark = "#a0a0a0",
    border = "#d4d4d4",
    accent = "#EC5B2B",
    accent_alt = "#c94d24",

    -- Syntax
    keyword = "#EC5B2B",
    func = "#c94d24",
    string = "#0062d1",
    number = "#EC5B2B",
    boolean = "#EC5B2B",
    constant = "#EC5B2B",
    variable = "#d1383d",
    variable_special = "#c94d24",
    type = "#b0851f",
    property = "#679cd9",
    operator = "#318795",
    comment = "#8a8a8a",
    tag = "#EC5B2B",
    attribute = "#c94d24",
    enum = "#d1383d",

    -- Diagnostic
    error = "#d1383d",
    warning = "#EC5B2B",
    info = "#318795",
    hint = "#8a8a8a",
    success = "#3d9a57",

    -- Git
    git_add = "#0062d1",
    git_change = "#b0851f",
    git_delete = "#d1383d",

    -- Terminal
    term_black = "#1a1a1a",
    term_red = "#d1383d",
    term_green = "#3d9a57",
    term_yellow = "#b0851f",
    term_blue = "#318795",
    term_magenta = "#c94d24",
    term_cyan = "#318795",
    term_white = "#ffffff",
  },
}

-- Helper to deep merge tables
local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      deep_merge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

function M.setup(opts)
  opts = opts or {}
  local style = opts.style or "dark"
  local transparent = opts.transparent or false
  local c = vim.deepcopy(colors[style])

  -- Apply color overrides
  if opts.colors then
    deep_merge(c, opts.colors)
  end

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "orng"

  -- Set background to NONE if transparent
  local bg = transparent and "NONE" or c.bg
  local bg_dark = transparent and "NONE" or c.bg_dark

  local groups = {
    -- Editor
    Normal = { fg = c.fg, bg = bg },
    NormalFloat = { fg = c.fg, bg = c.bg_dark },
    FloatBorder = { fg = c.border, bg = c.bg_dark },
    ColorColumn = { bg = c.bg_highlight },
    Cursor = { fg = c.bg, bg = c.accent },
    CursorLine = { bg = transparent and c.bg_highlight or c.bg_highlight },
    CursorLineNr = { fg = c.fg, bold = true },
    LineNr = { fg = c.fg_dark },
    SignColumn = { bg = bg },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border },
    Folded = { fg = c.comment, bg = c.bg_highlight },
    FoldColumn = { fg = c.comment },
    MatchParen = { fg = c.accent, bold = true },
    NonText = { fg = c.fg_dark },
    SpecialKey = { fg = c.fg_dark },
    Visual = { bg = c.bg_visual },
    VisualNOS = { bg = c.bg_visual },
    Whitespace = { fg = c.fg_dark },
    EndOfBuffer = { fg = c.bg_dark },

    -- Popup menu
    Pmenu = { fg = c.fg, bg = c.bg },
    PmenuSel = { fg = c.fg, bg = c.bg_visual },
    PmenuSbar = { bg = c.bg_highlight },
    PmenuThumb = { bg = c.fg_muted },

    -- Search
    Search = { fg = c.bg, bg = c.accent },
    IncSearch = { fg = c.bg, bg = c.accent_alt },
    CurSearch = { fg = c.bg, bg = c.accent_alt },
    Substitute = { fg = c.bg, bg = c.accent },

    -- Tabs
    TabLine = { fg = c.fg_muted, bg = c.bg },
    TabLineFill = { bg = c.bg },
    TabLineSel = { fg = c.fg, bg = c.bg_dark },

    -- Status line
    StatusLine = { fg = c.fg, bg = c.bg },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_dark },

    -- Messages
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.warning },
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.info },
    Question = { fg = c.info },

    -- Diff
    DiffAdd = { bg = "#1a3d2e" },
    DiffChange = { bg = "#2a2a1a" },
    DiffDelete = { bg = "#3d1a1a" },
    DiffText = { bg = "#3a3a2a" },

    -- Spelling
    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.info, undercurl = true },
    SpellRare = { sp = c.hint, undercurl = true },

    -- Syntax
    Comment = { fg = c.comment, italic = true },
    Constant = { fg = c.constant },
    String = { fg = c.string },
    Character = { fg = c.string },
    Number = { fg = c.number },
    Boolean = { fg = c.boolean },
    Float = { fg = c.number },
    Identifier = { fg = c.variable },
    Function = { fg = c.func },
    Statement = { fg = c.keyword },
    Conditional = { fg = c.keyword },
    Repeat = { fg = c.keyword },
    Label = { fg = c.keyword },
    Operator = { fg = c.operator },
    Keyword = { fg = c.keyword },
    Exception = { fg = c.keyword },
    PreProc = { fg = c.keyword },
    Include = { fg = c.keyword },
    Define = { fg = c.keyword },
    Macro = { fg = c.keyword },
    PreCondit = { fg = c.keyword },
    Type = { fg = c.type },
    StorageClass = { fg = c.keyword },
    Structure = { fg = c.type },
    Typedef = { fg = c.type },
    Special = { fg = c.accent },
    SpecialChar = { fg = c.string },
    Tag = { fg = c.tag },
    Delimiter = { fg = c.fg },
    SpecialComment = { fg = c.comment },
    Debug = { fg = c.warning },
    Underlined = { underline = true },
    Ignore = { fg = c.fg_dark },
    Error = { fg = c.error },
    Todo = { fg = c.accent, bold = true },

    -- Treesitter
    ["@attribute"] = { fg = c.attribute },
    ["@boolean"] = { fg = c.boolean },
    ["@character"] = { fg = c.string },
    ["@comment"] = { fg = c.comment, italic = true },
    ["@conditional"] = { fg = c.keyword },
    ["@constant"] = { fg = c.constant },
    ["@constant.builtin"] = { fg = c.constant },
    ["@constant.macro"] = { fg = c.constant },
    ["@constructor"] = { fg = c.func },
    ["@exception"] = { fg = c.keyword },
    ["@field"] = { fg = c.property },
    ["@float"] = { fg = c.number },
    ["@function"] = { fg = c.func },
    ["@function.builtin"] = { fg = c.func },
    ["@function.call"] = { fg = c.func },
    ["@function.macro"] = { fg = c.func },
    ["@include"] = { fg = c.keyword },
    ["@keyword"] = { fg = c.keyword },
    ["@keyword.function"] = { fg = c.keyword },
    ["@keyword.operator"] = { fg = c.operator },
    ["@keyword.return"] = { fg = c.keyword },
    ["@label"] = { fg = c.keyword },
    ["@method"] = { fg = c.func },
    ["@method.call"] = { fg = c.func },
    ["@namespace"] = { fg = c.fg },
    ["@number"] = { fg = c.number },
    ["@operator"] = { fg = c.operator },
    ["@parameter"] = { fg = c.variable },
    ["@property"] = { fg = c.property },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.accent },
    ["@repeat"] = { fg = c.keyword },
    ["@string"] = { fg = c.string },
    ["@string.escape"] = { fg = c.fg_muted },
    ["@string.regex"] = { fg = c.string },
    ["@string.special"] = { fg = c.string },
    ["@tag"] = { fg = c.tag },
    ["@tag.attribute"] = { fg = c.attribute },
    ["@tag.delimiter"] = { fg = c.fg },
    ["@text"] = { fg = c.fg },
    ["@text.danger"] = { fg = c.error },
    ["@text.emphasis"] = { italic = true },
    ["@text.literal"] = { fg = c.string },
    ["@text.reference"] = { fg = c.accent },
    ["@text.strong"] = { bold = true },
    ["@text.title"] = { fg = c.accent, bold = true },
    ["@text.todo"] = { fg = c.accent, bold = true },
    ["@text.underline"] = { underline = true },
    ["@text.uri"] = { fg = c.accent, underline = true },
    ["@text.warning"] = { fg = c.warning },
    ["@type"] = { fg = c.type },
    ["@type.builtin"] = { fg = c.type },
    ["@type.definition"] = { fg = c.type },
    ["@type.qualifier"] = { fg = c.keyword },
    ["@variable"] = { fg = c.variable },
    ["@variable.builtin"] = { fg = c.variable_special },

    -- LSP Semantic Tokens
    ["@lsp.type.class"] = { fg = c.type },
    ["@lsp.type.decorator"] = { fg = c.attribute },
    ["@lsp.type.enum"] = { fg = c.enum },
    ["@lsp.type.enumMember"] = { fg = c.constant },
    ["@lsp.type.function"] = { fg = c.func },
    ["@lsp.type.interface"] = { fg = c.type },
    ["@lsp.type.keyword"] = { fg = c.keyword },
    ["@lsp.type.macro"] = { fg = c.constant },
    ["@lsp.type.method"] = { fg = c.func },
    ["@lsp.type.namespace"] = { fg = c.fg },
    ["@lsp.type.parameter"] = { fg = c.variable },
    ["@lsp.type.property"] = { fg = c.property },
    ["@lsp.type.struct"] = { fg = c.type },
    ["@lsp.type.type"] = { fg = c.type },
    ["@lsp.type.typeParameter"] = { fg = c.type },
    ["@lsp.type.variable"] = { fg = c.variable },

    -- Diagnostics
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.warning, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.error, bg = c.bg_highlight },
    DiagnosticVirtualTextWarn = { fg = c.warning, bg = c.bg_highlight },
    DiagnosticVirtualTextInfo = { fg = c.info, bg = c.bg_highlight },
    DiagnosticVirtualTextHint = { fg = c.hint, bg = c.bg_highlight },

    -- Git
    GitSignsAdd = { fg = c.git_add },
    GitSignsChange = { fg = c.git_change },
    GitSignsDelete = { fg = c.git_delete },

    -- Telescope
    TelescopeNormal = { fg = c.fg, bg = c.bg_dark },
    TelescopeBorder = { fg = c.border, bg = c.bg_dark },
    TelescopePromptNormal = { fg = c.fg, bg = c.bg_highlight },
    TelescopePromptBorder = { fg = c.bg_highlight, bg = c.bg_highlight },
    TelescopePromptTitle = { fg = c.bg, bg = c.accent },
    TelescopePreviewTitle = { fg = c.bg, bg = c.success },
    TelescopeResultsTitle = { fg = c.bg, bg = c.info },
    TelescopeSelection = { bg = c.bg_visual },
    TelescopeSelectionCaret = { fg = c.accent },
    TelescopeMatching = { fg = c.accent, bold = true },

    -- NvimTree / Oil
    NvimTreeNormal = { fg = c.fg, bg = c.bg_dark },
    NvimTreeFolderIcon = { fg = c.accent },
    NvimTreeFolderName = { fg = c.fg },
    NvimTreeOpenedFolderName = { fg = c.accent },
    NvimTreeRootFolder = { fg = c.accent, bold = true },
    NvimTreeGitNew = { fg = c.git_add },
    NvimTreeGitDirty = { fg = c.git_change },
    NvimTreeGitDeleted = { fg = c.git_delete },

    -- Mini
    MiniStatuslineModeNormal = { fg = c.bg, bg = c.accent, bold = true },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.success, bold = true },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.info, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.error, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.warning, bold = true },

    -- Which-key
    WhichKey = { fg = c.accent },
    WhichKeyGroup = { fg = c.info },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeperator = { fg = c.fg_muted },
    WhichKeySeparator = { fg = c.fg_muted },
    WhichKeyFloat = { bg = c.bg_dark },

    -- CMP
    CmpItemAbbrMatch = { fg = c.accent, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.accent, bold = true },
    CmpItemKindFunction = { fg = c.func },
    CmpItemKindMethod = { fg = c.func },
    CmpItemKindVariable = { fg = c.variable },
    CmpItemKindKeyword = { fg = c.keyword },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindProperty = { fg = c.property },
    CmpItemKindUnit = { fg = c.constant },

    -- Lualine (if using lualine with custom theme)
    LualineNormal = { fg = c.fg, bg = c.bg },
  }

  -- Apply highlight overrides
  if opts.highlights then
    deep_merge(groups, opts.highlights)
  end

  -- Apply highlight groups
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  -- Terminal colors
  vim.g.terminal_color_0 = c.term_black
  vim.g.terminal_color_1 = c.term_red
  vim.g.terminal_color_2 = c.term_green
  vim.g.terminal_color_3 = c.term_yellow
  vim.g.terminal_color_4 = c.term_blue
  vim.g.terminal_color_5 = c.term_magenta
  vim.g.terminal_color_6 = c.term_cyan
  vim.g.terminal_color_7 = c.term_white
  vim.g.terminal_color_8 = c.fg_muted
  vim.g.terminal_color_9 = c.term_red
  vim.g.terminal_color_10 = c.term_green
  vim.g.terminal_color_11 = c.term_yellow
  vim.g.terminal_color_12 = c.term_blue
  vim.g.terminal_color_13 = c.term_magenta
  vim.g.terminal_color_14 = c.term_cyan
  vim.g.terminal_color_15 = c.fg
end

-- Create colorscheme commands
vim.api.nvim_create_user_command("OrngDark", function()
  M.setup({ style = "dark" })
end, {})

vim.api.nvim_create_user_command("OrngLight", function()
  M.setup({ style = "light" })
end, {})

return M
