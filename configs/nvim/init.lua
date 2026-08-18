-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.clipboard = "unnamedplus"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- Colorscheme
  {
    "EdenEast/nightfox.nvim",
    priority = 1000, -- load before other plugins so it's ready when they init
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true, -- keeps a transparent bg, like before
        },
        palettes = {
          terafox = {
            bg0 = "#0a0a0d",   -- near-black sky from the wallpaper
            bg1 = "#12141a",
            bg2 = "#1a2420",
            bg3 = "#223028",
            fg0 = "#e8ddc8",   -- warm off-white, skin-adjacent
            fg1 = "#d9c9a8",
            sel0 = "#2a3d2f",
            sel1 = "#35503d",

            red = "#c1272d",    -- dress red
            green = "#6fae3a",  -- grass
            yellow = "#d99a44", -- soil highlight / amber
            blue = "#4a8fa8",   -- deep water shadow
            magenta = "#8b5fbf",-- crystal purple
            cyan = "#5fd6c8",   -- teal glow swirl
            orange = "#d9702e", -- small orange accent in the moss

            comment = "#4a5d52",
          },
        },
      })
      vim.cmd("colorscheme terafox") -- retinted to match the island wallpaper
    end,
  },
  --Real syntax highlighting (parses actual code structure, not just regex)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the rewritten, current version
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install({ "lua", "python", "java", "c", "cpp", "bash", "nix", "markdown" })
      -- New API: highlighting is turned on per-filetype via an autocmd,
      -- not via a configs.setup({ highlight = { enable = true } }) call.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua", "python", "java", "c", "cpp", "bash", "nix", "markdown" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  -- Statusline matching the glass theme
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = "",
          section_separators = "",
        },
      })
    end,
  },
  -- File explorer sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },
  -- Fuzzy finder: files, grep, buffers
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },
  -- Git change indicators in the gutter
  { "lewis6991/gitsigns.nvim", config = true },
  -- Auto-close brackets/quotes
  { "windwp/nvim-autopairs", config = true },
  -- Toggle comments with gcc / gc
  { "numToStr/Comment.nvim", config = true },
  -- Language servers: autocomplete, go-to-definition, diagnostics
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        -- jdtls comes from nixpkgs instead (Mason binaries don't run on NixOS)
        ensure_installed = { "pyright", "clangd", "lua_ls" },
      })
    end,
  },
  -- Completion engine + snippets (this is what gives you sout -> System.out.println())
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
})

-- Basic sane defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.g.mapleader = " "

-- LSP server setup
-- (jdtls comes from jdt-language-server in nixpkgs, so it's already on $PATH,
-- no Mason install needed for it)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.config("lua_ls", { capabilities = capabilities })
vim.lsp.config("jdtls", { capabilities = capabilities })

vim.lsp.enable({ "pyright", "clangd", "lua_ls", "jdtls" })
