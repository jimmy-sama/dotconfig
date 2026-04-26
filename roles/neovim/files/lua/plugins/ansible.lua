return {
  -- Provides Ansible syntax highlighting and other niceties.
  -- Filetype detection is handled in init.lua to ensure correctness.
  { 'pearofducks/ansible-vim' },

  -- Linter for Ansible and Python.
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        ['yaml.ansible'] = { 'ansiblels' },
        python = { 'ruff' },
      }
      -- Automatically run linter on save.
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- Ensures linters and formatters are installed.
  {
    'mason-org/mason.nvim',
    opts = {
      ensure_installed = {
        'ansiblels',
        'ruff',
        'yamlfix',
        'black',
      },
    },
  },
}
