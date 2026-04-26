-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load configuration files
require("core.options")
require("core.keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Put's lazy into the runtimepath for neovim
vim.opt.runtimepath:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "ellisonleao/gruvbox.nvim", config = function() vim.cmd.colorscheme "gruvbox" end },
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  -- checker = { enabled = true },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false, -- default: true
  }
})

-- Force filetype for all YAML files to be Ansible
-- This creates a dedicated group to ensure this rule is not overridden.
local ansible_ft_group = vim.api.nvim_create_augroup('AnsibleFiletype', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = ansible_ft_group,
  pattern = { '*.yaml', '*.yml' },
  command = 'set filetype=yaml.ansible',
})
