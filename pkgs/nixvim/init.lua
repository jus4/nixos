local nvim_lsp = require("lspconfig")

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("t","<Esc>", "<C-\\><C-n>")

vim.filetype.add({ extension = { templ = "templ" } })

vim.cmd([[
  let g:copilot_no_tab_map = v:true
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
]])


-- Set a GEM_HOME to a user-writable path to avoid EROFS
vim.env.GEM_HOME = vim.fn.expand("~/.gem/ruby/3.3.0")
vim.env.GEM_PATH = vim.env.GEM_HOME
vim.env.PATH = vim.env.GEM_HOME .. "/bin:" .. vim.env.PATH

-- Optional: skip Bundler auto-setup if gems are already available
vim.env.RUBY_LSP_SKIP_BUNDLER_SETUP = "1"

nvim_lsp.ruby_lsp.setup({
  cmd = { "ruby-lsp" },  -- this will pick up the flake-installed ruby-lsp
  filetypes = { "ruby" },
  root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git"),
  settings = {
    -- you can add Ruby-LSP-specific settings here
  },
})

-- lspconfig.templ.setup({
--   filetypes = { "templ" },
-- })

--tnoremap <M-[> <Esc>
--tnoremap <C-v><Esc> <Esc>
