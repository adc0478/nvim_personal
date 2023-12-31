local M = {}
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local conf = require("telescope.config").values
    local NuiTable = require("nui.table")
local Object = require("nui.object")
local Text = require("nui.text")
local Line = require("nui.line")
local _ = require("nui.utils")
function ventana2()

local tbl = NuiTable({
  bufnr = vim.api.nvim_get_current_buf(),
  columns = {
    {
      align = "center",
      header = "Name",
      columns = {
        { accessor_key = "firstName", header = "First" },
        {
          id = "lastName",
          accessor_fn = function(row)
            return row.lastName
          end,
          header = "Last",
        },
      },
    },
    {
      align = "right",
      accessor_key = "age",
      cell = function(cell)
        return Text(tostring(cell.get_value()), "DiagnosticInfo")
      end,
      header = "Age",
    },
  },
  data = {
    { firstName = "John", lastName = "Doe", age = 42 },
    { firstName = "Jane", lastName = "Doe", age = 27 },
  },
})

tbl:render()
end
function crearVentanaFlotante()

-- our picker function: colors
  pickers.new({}, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = { 'aaa', 'cccc', 'dddd'}
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_,map)
        map('i',"<cr>",function (prompt_bufnr)
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            print(entry[1])
        end)
        return true
    end
  }):find()

-- to execute the function
end
function M.app(opt)
    vim.keymap.set('n','<C-'.. opt['key'] .. '>',function()
        -- crearVentanaFlotante()
        ventana2()
    end)

end

return M 
