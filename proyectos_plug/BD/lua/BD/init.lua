require ("io")
local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local conf = require("telescope.config").values
local obj = {}
local M = {}
function crearVentana()
    local data ={}
    local archivo = io.open(obj:salida(obtener_proyecto()),'r')
    for linea in archivo:lines() do
        table.insert(data,linea)
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    local opciones = {
        style = "minimal",
        relative = "editor",
        width = 130,
        height = 10,
        row = 5,
        col = 5,
        border = "single",
    }

    local win_id = vim.api.nvim_open_win(bufnr, true, opciones)

    -- Puedes personalizar el contenido de la ventana
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)

    -- Puedes cerrar la ventana flotante con `vim.api.nvim_win_close(win_id, true)`
end

function obj:salida (proyecto)
    if proyecto == nil then
        return ""
    end
    return '/opt/lampp/htdocs/' .. proyecto .. '/BasesConfig.txt'
end
function obtener_tablas (proyecto)
    local salida = obj:salida(proyecto)
    vim.api.nvim_command('!mariadb ' .. proyecto .. ' -e "show tables" > ' .. salida)
    local archivo = io.open(salida,r)
    local lista = {}
    table.insert(lista,"salir")
    for linea in archivo:lines() do
        table.insert(lista,linea)
    end
    archivo:close()
    return lista --debo asegurarme que sea una tabla
end
function obtener_proyecto()
    return vim.g.proyecto
end
function accion_sobre_bd(tablaBD, proyecto)
    local seleccion = "'select * " .. "from " .. tablaBD .. "'"
    local descripcion = "'describe " .. tablaBD .. "'"
-------------------------------------------
pickers.new({}, {
    prompt_title = "indique accion sobre " .. tablaBD,
    finder = finders.new_table {
      results = {seleccion,descripcion,'comando_personalizado'}
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_,map)
        map('i',"<cr>",function (prompt_bufnr)
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            local choice = (entry[1])
            if (choice == "comando_personalizado") then
               vim.ui.input({prompt="Crear la sentencia SQL:"},function (input)
                    vim.api.nvim_command("!mariadb " .. proyecto .. " -e '" .. input .. "' > " .. obj:salida(proyecto))
               end)
            else
                vim.api.nvim_command("!mariadb " .. proyecto .. " -e " .. choice .. ' > ' .. obj:salida(proyecto))
            end
            crearVentana()
        end)
        return true
    end
  }):find()

-------------------------------------------

end
function listar_tablas(tablas,nombre_proyecto)
 pickers.new({}, {
    prompt_title = "seleccione un proyecto",
    finder = finders.new_table {
      results = tablas
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_,map)
        map('i',"<cr>",function (prompt_bufnr)
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            local choice = (entry[1])
            accion_sobre_bd(choice,nombre_proyecto)
        end)
        return true
    end
  }):find()
end
function M.app(opt)
    vim.keymap.set('n','<C-'.. opt["key"] .. '>',function()
        local nombre_proyecto = obtener_proyecto()
        if nombre_proyecto ~= nil then
            local tablas = obtener_tablas(nombre_proyecto) 
            listar_tablas(tablas,nombre_proyecto)
        end
    end,{noremap=true,silent=true})
end

return M
