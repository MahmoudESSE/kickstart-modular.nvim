-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.g.heirline_as_ui = true

return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-tree/nvim-web-devicons' }, -- not strictly required, but recommended
  { 'MunifTanjim/nui.nvim' },
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
    enabled = true,
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    dependencies = {},
    config = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { silent = true, buffer = bufnr }

      vim.keymap.set('n', '<leader>a', function()
        vim.cmd.RustLsp '󱐋codeAction' -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, opts)

      vim.g.rustaceanvim = function()
        local cfg = require 'rustaceanvim.config'
        return {
          tools = {
            hover_actions = {
              replace_builtin_hover = false,
            },
          },
        }
      end
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    dependencies = {
      'mrcjkb/rustaceanvim',
    },
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
          enabled = false,
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

      vim.keymap.set('n', '<leader>ct', crates.toggle, { desc = 'Crate [T]oggle', silent = true })
      vim.keymap.set('n', '<leader>cr', crates.reload, { desc = 'Crate [R]eload', silent = true })

      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, { desc = 'Crate [V]ersion', silent = true })
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup, { desc = 'Crate [F]eatures', silent = true })
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, { desc = 'Crate [D]ependencies', silent = true })

      vim.keymap.set('n', '<leader>cu', crates.update_crate, { desc = 'Crate [U]pdate', silent = true })
      vim.keymap.set('v', '<leader>cu', crates.update_crates, { desc = 'Crate [U]pdate', silent = true })
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates, { desc = 'Crate Upate [A]ll', silent = true })
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, { desc = 'Crate [U]pgrade', silent = true })
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, { desc = 'Crate [U]pgrade', silent = true })
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, { desc = 'Crate Upgrade [A]ll', silent = true })

      vim.keymap.set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table, { desc = 'Crate [E]xpand', silent = true })
      vim.keymap.set('n', '<leader>cX', crates.extract_crate_into_table, { desc = 'Crate [V]ersion', silent = true })

      vim.keymap.set('n', '<leader>cH', crates.open_homepage, { desc = 'Crate [H]omepage', silent = true })
      vim.keymap.set('n', '<leader>cR', crates.open_repository, { desc = 'Crate [R]epository', silent = true })
      vim.keymap.set('n', '<leader>cD', crates.open_documentation, { desc = 'Crate [D]ocumentation', silent = true })
      vim.keymap.set('n', '<leader>cC', crates.open_crates_io, { desc = 'Crate [C]rates.io', silent = true })
      vim.keymap.set('n', '<leader>cL', crates.open_lib_rs, { desc = 'Crate [L]ib.rs', silent = true })
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'mrcjkb/rustaceanvim',
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'rustaceanvim.neotest',
        },
      }
    end,
  },
  {
    'smoka7/hop.nvim',
    version = 'v2.7.0',
    opts = {
      jump_on_sole_occurrence = false,
      current_line_only = false,
      extensions = nil,
    },
    config = function(opts)
      -- you can configure Hop the way you like here; see :h hop-config
      local hop = require 'hop'
      hop.setup(opts)
      local directions = require('hop.hint').HintDirection

      vim.keymap.set('', 'f', function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false }
      end, { remap = true })

      vim.keymap.set('', 'F', function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false }
      end, { remap = true })

      vim.keymap.set('', 't', function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 }
      end, { remap = true })

      vim.keymap.set('', 'T', function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 }
      end, { remap = true })
    end,
  },
  {
    'rcarriga/nvim-notify',
    opts = {

      stages = 'slide',
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      local noice = require 'noice'
      noice.setup {
        -- add any options here

        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function(_, opts)
      require('aerial').setup {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
        layout = {
          width = 40,
        },
        show_guides = true,
      }
      vim.keymap.set({ 'n' }, '<leader>Aa', '<cmd>AerialToggle!<CR>')
    end,
  },
  {
    'rebelot/heirline.nvim',
    enabled = vim.g.heirline_as_ui,
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-telescope/telescope.nvim',
      'zeioth/compiler.nvim',
      'mfussenegger/nvim-dap',
      'echasnovski/mini.nvim',
      'nvim-neo-tree/neo-tree.nvim',
      'stevearc/aerial.nvim',
      'folke/zen-mode.nvim',
      'linux-cultist/venv-selector.nvim',
      'Zeioth/heirline-components.nvim',
    },
    event = 'UIEnter',
    config = function()
      local lib = require 'heirline-components.all'
      local opts = {
        opts = {
          disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
            local is_disabled = not require('heirline-components.buffer').is_valid(args.buf)
              or lib.condition.buffer_matches({
                buftype = { 'terminal', 'prompt', 'nofile', 'help', 'quickfix' },
                filetype = { 'NvimTree', 'neo%-tree', 'dashboard', 'Outline', 'aerial' },
              }, args.buf)
            return is_disabled
          end,
        },
        tabline = { -- UI upper bar
          lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers(),
          lib.component.fill { hl = { bg = 'tabline_bg' } },
          lib.component.tabline_tabpages(),
        },
        winbar = { -- UI breadcrumbs bar
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          fallthrough = false,
          -- Winbar for terminal, neotree, and aerial.
          {
            condition = function()
              return not lib.condition.is_active()
            end,
            {
              lib.component.neotree(),
              lib.component.fill(),
              lib.component.aerial(),
            },
          },
          -- Regular winbar
          {
            lib.component.fill(),
            lib.component.breadcrumbs(),
            lib.component.fill(),
            lib.component.aerial(),
          },
        },
        statuscolumn = { -- UI left column
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,
        statusline = { -- UI statusbar
          hl = { fg = 'fg', bg = 'bg' },
          lib.component.mode(),
          lib.component.file_info(),
          lib.component.git_branch(),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.treesitter(),
          lib.component.lsp(),
          lib.component.file_encoding(),
          lib.component.nav(),
          lib.component.mode { surround = { separator = 'right' } },
        },
      }
      local heirline = require 'heirline'
      local heirline_components = require 'heirline-components.all'

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      -- add any custom options here
    },
    config = function()
      local persistence = require 'persistence'
      persistence.setup()

      vim.api.nvim_create_autocmd('BufReadPre', {
        desc = 'Start Session on first buffer read',
        group = vim.api.nvim_create_augroup('kickstart-persistence-start-session', { clear = true }),
        callback = function()
          persistence.start()
        end,
      })

      -- save the session for the current directory
      vim.keymap.set('n', '<leader>Ss', function()
        persistence.save()
      end, { desc = '[S]ave Session' })

      -- start the session for the current directory
      vim.keymap.set('n', '<leader>SS', function()
        persistence.start()
      end, { desc = '[S]tart Session' })

      -- load the session for the current directory
      vim.keymap.set('n', '<leader>Sl', function()
        persistence.load()
      end, { desc = '[L]oad Session' })

      -- select a session to load
      vim.keymap.set('n', '<leader>SS', function()
        persistence.select()
      end, { desc = '[S]elect Session' })

      -- load the last session
      vim.keymap.set('n', '<leader>SL', function()
        persistence.load { last = true }
      end, { desc = '[L]oad Last Session' })
    end,
  },
}
