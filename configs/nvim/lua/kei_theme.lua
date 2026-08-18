local M = {}

function M.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "kei"

  local c = {
    bg      = "#071A1B", -- near-black teal, the deep background
    bg2     = "#0F2B2C", -- slightly lifted, for cursorline/menus
    bg3     = "#163C3D", -- lifted further, for visual selection/borders

    fg      = "#E8D9BB", -- warm sand, skin tone
    fg_dim  = "#6E8C87", -- muted teal-gray, for comments/line numbers

    teal    = "#4FBFB0", -- main water color -> functions
    cyan    = "#8FE0D6", -- lighter water highlight -> identifiers/constants

    red     = "#C0394A", -- dress red -> keywords only, not bold-spammed
    coral   = "#D97757", -- warmer red-orange -> conditionals/repeat, for variety

    orange  = "#E0A458", -- orange fish -> strings
    yellow  = "#E8C97A", -- warm highlight -> numbers/booleans

    green   = "#8FBF8A", -- success states, git add, hints
    blue    = "#6FB8D9", -- small blue fish -> types/structure

    muted   = "#5C7470", -- desaturated teal-gray -> punctuation/operators
    gray    = "#3E504D", -- line numbers, very low-key
  }

  local set = vim.api.nvim_set_hl

  -- UI
  set(0, "Normal",        { fg = c.fg, bg = "none" })
  set(0, "NormalNC",      { fg = c.fg, bg = "none" })
  set(0, "EndOfBuffer",   { fg = c.bg, bg = "none" })
  set(0, "SignColumn",    { bg = "none" })
  set(0, "FoldColumn",    { bg = "none" })
  set(0, "LineNr",        { fg = c.gray, bg = "none" })
  set(0, "CursorLineNr",  { fg = c.teal, bold = true })
  set(0, "CursorLine",    { bg = c.bg2 })
  set(0, "Visual",        { bg = c.bg3 })
  set(0, "Search",        { fg = c.bg, bg = c.yellow })
  set(0, "IncSearch",     { fg = c.bg, bg = c.orange })
  set(0, "VertSplit",     { fg = c.bg3 })
  set(0, "WinSeparator",  { fg = c.bg3 })

  set(0, "Pmenu",         { fg = c.fg, bg = c.bg2 })
  set(0, "PmenuSel",      { fg = c.bg, bg = c.teal })

  set(0, "StatusLine",    { fg = c.fg, bg = c.bg2 })
  set(0, "StatusLineNC",  { fg = c.fg_dim, bg = c.bg2 })

  set(0, "NormalFloat",   { bg = c.bg2 })
  set(0, "FloatBorder",   { fg = c.teal, bg = c.bg2 })

  -- Syntax
  set(0, "Comment",       { fg = c.fg_dim, italic = true })

  set(0, "String",        { fg = c.orange })
  set(0, "Character",     { fg = c.orange })
  set(0, "Number",        { fg = c.yellow })
  set(0, "Boolean",       { fg = c.yellow })

  -- Keywords: dress-red, but NOT bold everywhere -- reserve bold for the
  -- structural ones (public/class/static) so it reads as emphasis, not noise
  set(0, "Keyword",       { fg = c.red })
  set(0, "StorageClass",  { fg = c.red, bold = true }) -- public, static, private
  set(0, "Conditional",   { fg = c.coral })
  set(0, "Repeat",        { fg = c.coral })

  set(0, "Function",      { fg = c.teal })
  set(0, "Identifier",    { fg = c.cyan })

  set(0, "Type",          { fg = c.blue })
  set(0, "Structure",     { fg = c.blue })

  set(0, "Constant",      { fg = c.cyan })

  set(0, "Operator",      { fg = c.muted })
  set(0, "Delimiter",     { fg = c.muted })
  set(0, "Punctuation",   { fg = c.muted })

  -- Diagnostics
  set(0, "DiagnosticError", { fg = c.red })
  set(0, "DiagnosticWarn",  { fg = c.orange })
  set(0, "DiagnosticInfo",  { fg = c.blue })
  set(0, "DiagnosticHint",  { fg = c.green })

  -- Git
  set(0, "GitSignsAdd",    { fg = c.green })
  set(0, "GitSignsChange", { fg = c.orange })
  set(0, "GitSignsDelete", { fg = c.red })

  -- Treesitter
  set(0, "@comment",       { link = "Comment" })
  set(0, "@string",        { link = "String" })
  set(0, "@keyword",       { link = "Keyword" })
  set(0, "@keyword.function", { fg = c.coral })
  set(0, "@keyword.return",   { fg = c.coral, bold = true })
  set(0, "@function",      { link = "Function" })
  set(0, "@function.call", { link = "Function" })
  set(0, "@type",          { link = "Type" })
  set(0, "@type.builtin",  { fg = c.blue, italic = true })
  set(0, "@constant",      { link = "Constant" })
  set(0, "@variable",      { fg = c.fg })
  set(0, "@variable.parameter", { fg = c.fg, italic = true })
  set(0, "@property",      { fg = c.cyan })
  set(0, "@punctuation.bracket",  { fg = c.muted })
  set(0, "@punctuation.delimiter", { fg = c.muted })
  set(0, "@operator",      { fg = c.muted })
end

return M
