return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- Mini Added Functionality
      require('mini.extra').setup {}

      local MiniExtra = require 'mini.extra'
      local MiniIcons = require 'mini.icons'
      local MiniMisc = require 'mini.misc'

      MiniIcons.setup {}

      MiniMisc.setup {}

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          B = MiniExtra.gen_ai_spec.buffer(),
          D = MiniExtra.gen_ai_spec.diagnostic(),
          I = MiniExtra.gen_ai_spec.indent(),
          L = MiniExtra.gen_ai_spec.line(),
          N = MiniExtra.gen_ai_spec.number(),
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      if vim.g.heirline_as_ui == false then
        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        local section_marks = function()
          return require('grapple').statusline {}
        end

        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
          local git = statusline.section_git { trunc_width = 40 }
          local diff = statusline.section_diff { trunc_width = 75 }
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
          local lsp = statusline.section_lsp { trunc_width = 75 }
          local filename = statusline.section_filename { trunc_width = 140 }
          local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
          local location = statusline.section_location { trunc_width = 75 }
          local search = statusline.section_searchcount { trunc_width = 75 }
          local marks = section_marks()

          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename, marks } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          }
        end

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v/%l'
        end
      end

      require('mini.tabline').setup {}

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim

      --  Setup a starter splash screen
      local starter = require 'mini.starter'

      --  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      --  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      --  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      --  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      --  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      --  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      --
      local starter_header = function()
        return ''
          .. '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗\n'
          .. '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║\n'
          .. '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║\n'
          .. '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║\n'
          .. '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║\n'
          .. '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝\n'
      end

      -- TODO: remodel this sessions section to work with folke/persistence.nvim
      --
      --- Section with |MiniSessions| sessions
      ---
      --- Sessions are taken from |MiniSessions.detected|. Notes:
      --- - If it shows "'mini.sessions' is not set up", it means that you didn't
      ---   call `require('mini.sessions').setup()`.
      --- - If it shows "There are no detected sessions in 'mini.sessions'", it means
      ---   that there are no sessions at the current sessions directory. Either
      ---   create session or supply different directory where session files are
      ---   stored (see |MiniSessions.setup|).
      --- - Local session (if detected) is always displayed first.
      ---
      ---@param n number|nil Number of returned items. Default: 5.
      ---@param recent boolean|nil Whether to use recent sessions (instead of
      ---   alphabetically by name). Default: true.
      ---
      ---@return __starter_section_fun
      local starter_sections_sessions = function(n, recent)
        n = n or 5
        if recent == nil then
          recent = true
        end

        return function()
          if _G.MiniSessions == nil then
            return { { name = [['mini.sessions' is not set up]], action = '', section = 'Sessions' } }
          end

          local items = {}
          for session_name, session in pairs(_G.MiniSessions.detected) do
            table.insert(items, {
              _session = session,
              name = ('%s%s'):format(session_name, session.type == 'local' and ' (local)' or ''),
              action = ([[lua _G.MiniSessions.read('%s')]]):format(session_name),
              section = 'Sessions',
            })
          end

          if vim.tbl_count(items) == 0 then
            return { { name = [[There are no detected sessions in 'mini.sessions']], action = '', section = 'Sessions' } }
          end

          local sort_fun
          if recent then
            sort_fun = function(a, b)
              local a_time = a._session.type == 'local' and math.huge or a._session.modify_time
              local b_time = b._session.type == 'local' and math.huge or b._session.modify_time
              return a_time > b_time
            end
          else
            sort_fun = function(a, b)
              local a_name = a._session.type == 'local' and '' or a.name
              local b_name = b._session.type == 'local' and '' or b.name
              return a_name < b_name
            end
          end
          table.sort(items, sort_fun)

          -- Take only first `n` elements and remove helper fields
          return vim.tbl_map(function(x)
            x._session = nil
            return x
          end, vim.list_slice(items, 1, n))
        end
      end

      starter.setup {
        evaluate_single = true,

        header = starter_header,

        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(10, false),
          starter.sections.recent_files(10, true),
          pcall(starter_sections_sessions(5, true)),
        },

        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Builtin actions' }),
          starter.gen_hook.padding(3, 2),
        },
      }

      require('mini.animate').setup {}

      require('mini.basics').setup {
        options = {
          extra_ui = true,
          win_borders = 'double',
          move_with_alt = true,
        },
        mappings = {
          windows = true,
          option_toggle_prefix = [[|]],
        },
      }

      require('mini.bracketed').setup {}

      require('mini.bufremove').setup {}
      local MiniBufremove = require 'mini.bufremove'

      vim.keymap.set('n', '<leader>bc', function()
        MiniBufremove.delete()
      end, { desc = '[C]lose Buffer' })

      vim.keymap.set('n', '<leader>C', function()
        MiniBufremove.delete()
      end, { desc = '[C]lose Buffer' })

      local MiniBracketed = require 'mini.bracketed'
      vim.keymap.set('n', '<leader>bn', function()
        MiniBracketed.buffer('forward', {})
      end, { desc = '[N]ext Buffer' })
      vim.keymap.set('n', '<leader>bp', function()
        MiniBracketed.buffer('backward', {})
      end, { desc = '[P]revious Buffer' })

      require('mini.cursorword').setup {}

      -- Don't highlight current word.
      --
      -- vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', {})
      if vim.g.gitsigns_for_hunks == false then
        local MiniDiff = require 'mini.diff'
        MiniDiff.setup {
          view = {
            style = 'sign',
            signs = { add = '+', change = '~', delete = '-' },
          },
          options = {
            wrap_goto = true,
          },
        }
      end

      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {

          fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
          hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
          todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
          note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      -- Neovim Custom Motions
      if vim.g.key_binding_helper == false then
        local miniclue = require 'mini.clue'
        if vim.g.which_key_enabled == false then
          miniclue.setup {
            window = {
              config = {
                anchor = 'SW',
                row = 'auto',
                col = 'auto',
                width = vim.api.nvim_get_current_win() <= 30 and 'auto' or 80,
              },
            },
            triggers = {
              -- Leader triggers
              { mode = 'n', keys = '<Leader>' },
              { mode = 'x', keys = '<Leader>' },

              -- Built-in completion
              { mode = 'i', keys = '<C-x>' },

              -- `g` key
              { mode = 'n', keys = 'g' },
              { mode = 'x', keys = 'g' },

              -- Marks
              { mode = 'n', keys = "'" },
              { mode = 'n', keys = '`' },
              { mode = 'x', keys = "'" },
              { mode = 'x', keys = '`' },

              -- Registers
              { mode = 'n', keys = '"' },
              { mode = 'x', keys = '"' },
              { mode = 'i', keys = '<C-r>' },
              { mode = 'c', keys = '<C-r>' },

              -- Window commands
              { mode = 'n', keys = '<C-w>' },

              -- `z` key
              { mode = 'n', keys = 'z' },
              { mode = 'x', keys = 'z' },

              -- bracketed
              { mode = 'n', keys = ']' },
              { mode = 'n', keys = '[' },

              -- window
              { mode = 'n', keys = '<C-w>' },

              { mode = 'n', keys = 'y' },
              { mode = 'v', keys = 'y' },
              { mode = 'x', keys = 'y' },
            },

            clues = {
              -- Enhance this by adding descriptions for <Leader> mapping groups
              miniclue.gen_clues.builtin_completion(),
              miniclue.gen_clues.g(),
              miniclue.gen_clues.marks(),
              miniclue.gen_clues.registers(),
              miniclue.gen_clues.windows {
                submode_move = true,
                submode_navigate = true,
                submode_resize = true,
              },
              miniclue.gen_clues.z(),

              { mode = 'n', keys = 'yy', desc = 'yank line' },
              -- MainMenu
              { mode = 'n', keys = '<leader>c', desc = '[C]ode' },
              { mode = 'n', keys = '<leader>d', desc = '[D]ocument' },
              { mode = 'n', keys = '<leader>r', desc = '[R]ename' },
              { mode = 'n', keys = '<leader>s', desc = '[S]earch' },
              { mode = 'n', keys = '<leader>w', desc = '[W]orkspace' },
              { mode = 'n', keys = '<leader>t', desc = '[T]oggle' },
              { mode = 'n', keys = '<leader>b', desc = '[B]uffer' },

              -- bracketed
              { mode = 'n', keys = ']b', postkeys = ']' },
              { mode = 'n', keys = ']w', postkeys = ']' },

              { mode = 'n', keys = '[b', postkeys = '[' },
              { mode = 'n', keys = '[w', postkeys = '[' },
            },
          }
        end
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
