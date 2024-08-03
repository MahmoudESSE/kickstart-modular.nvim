-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'aserowy/tmux.nvim',
    opts = {
      sync_clipboard = true,
      redirect_to_clipboard = true,
      copy_sync = {
        enable = false,
      },
    },
  },
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git', -- also try out "git_branch"
      icons = true, -- setting to "true" requires "nvim-web-devicons"
      status = true,
    },

    keys = {
      { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
      { '<leader>e', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

      { '<c-n>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
      { '<c-p>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
    },
  },

  'kkharji/sqlite.lua',
  {

    'gbprod/yanky.nvim',
    requires = { 'kkharji/sqlite.lua' },
    config = function()
      require('yanky').setup {
        ring = {
          history_length = 1000,
          storage = 'sqlite',
        },
        highlight = {
          timer = 200,
        },
        system_clipboard = {
          sync_with_ring = true,
        },
        textobj = {
          enabled = true,
        },
      }

      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

      vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')

      vim.keymap.set('n', ']p', '<Plug>(YankyPutIndentAfterLinewise)')
      vim.keymap.set('n', '[p', '<Plug>(YankyPutIndentBeforeLinewise)')
      vim.keymap.set('n', ']P', '<Plug>(YankyPutIndentAfterLinewise)')
      vim.keymap.set('n', '[P', '<Plug>(YankyPutIndentBeforeLinewise)')

      vim.keymap.set('n', '>p', '<Plug>(YankyPutIndentAfterShiftRight)')
      vim.keymap.set('n', '<p', '<Plug>(YankyPutIndentAfterShiftLeft)')
      vim.keymap.set('n', '>P', '<Plug>(YankyPutIndentBeforeShiftRight)')
      vim.keymap.set('n', '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)')

      vim.keymap.set('n', '=p', '<Plug>(YankyPutAfterFilter)')
      vim.keymap.set('n', '=P', '<Plug>(YankyPutBeforeFilter)')

      vim.keymap.set({ 'o', 'x' }, 'lp', function()
        require('yanky.textobj').last_put()
      end, {})
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      local bufnr = vim.api.nvim_get_current_buf()

      vim.keymap.set('n', '<leader>a', function()
        vim.cmd.RustLsp '󱐋codeAction' -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, { silent = true, buffer = bufnr })
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup {
        completion = {
          cmp = {
            enabled = true,
          },
          crates = {
            enabled = true,
            max_results = 8, -- The maximum number of search results to display
            min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
          },
        },
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
      require('crates.completion.cmp').setup()

      local crates = require 'crates'

      vim.keymap.set('n', '<leader>ct', crates.toggle, { desc = '[C]rate [T]oggle', silent = true })
      vim.keymap.set('n', '<leader>cr', crates.reload, { desc = '[C]rate [R]eload', silent = true })

      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = '[C]rate [V]ersion', silent = true })
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = '[C]rate [F]eatures', silent = true })
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, { desc = '[C]rate [D]ependencies', silent = true })

      vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = '[C]rate [U]pdate', silent = true })
      vim.keymap.set('v', '<leader>cu', crates.update_crates, { desc = '[C]rate [U]pdate', silent = true })
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = '[C]rate Upate [A]ll', silent = true })
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, { desc = '[C]rate [U]pgrade', silent = true })
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, { desc = '[C]rate [U]pgrade', silent = true })
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, { desc = '[C]rate Upgrade [A]ll', silent = true })

      vim.keymap.set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table, { desc = '[C]rate [E]xpand', silent = true })
      vim.keymap.set('n', '<leader>cX', crates.extract_crate_into_table, { desc = '[C]rate [V]ersion', silent = true })

      vim.keymap.set('n', '<leader>cH', crates.open_homepage, { desc = '[C]rate [H]omepage', silent = true })
      vim.keymap.set('n', '<leader>cR', crates.open_repository, { desc = '[C]rate [R]epository', silent = true })
      vim.keymap.set('n', '<leader>cD', crates.open_documentation, { desc = '[C]rate [D]ocumentation', silent = true })
      vim.keymap.set('n', '<leader>cC', crates.open_crates_io, { desc = '[C]rate [C]rates.io', silent = true })
      vim.keymap.set('n', '<leader>cL', crates.open_lib_rs, { desc = '[C]rate [L]ib.rs', silent = true })
    end,
  },
}
