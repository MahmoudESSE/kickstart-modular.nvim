-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end
vim.g.which_key_enabled = true
vim.g.key_binding_helper = false

if vim.g.key_binding_helper == false then
  return {
    { -- Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      enabled = vim.g.which_key_enabled,
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      config = function() -- This is the function that runs, AFTER loading
        local wk = require 'which-key'
        wk.setup {
          preset = 'modern',
          delay = 300,
          win = {
            border = 'single',
            width = 70,
            height = { min = 4, max = 40 },
            col = vim.api.nvim_win_get_width(0),
            title_pos = 'left',
          },
        }

        -- Document existing key chains
        wk.add {
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk' },
          { '<leader>b', group = '[B]uffer', mode = { 'n' } },
          { '<leader>S', group = '[S]ession', mode = { 'n' } },
          { '<leader>A', group = '[A]erial', mode = { 'n' } },
        }
      end,
    },
  }
end

return {}
-- vim: ts=2 sts=2 sw=2 et
