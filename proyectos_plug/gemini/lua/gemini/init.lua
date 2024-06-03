local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local M = {}
function solicitudHttp(promp,contexto,salida,script_bash)
    local parametros = "'".. promp .. "' '" .. contexto .. "' '" .. salida .. "'"
    vim.api.nvim_command('!'..script_bash .. " " ..  parametros)
    procesar_salida(salida)
end
function procesar_salida(salida)

    local tabla = {}
    local archivo = io.open(salida,"r")
    for linea in archivo:lines() do
        table.insert(tabla,linea)
    end
    archivo:close()
    crear_ventana(tabla)
end

function crear_ventana(datos)
    local bufnr = vim.api.nvim_create_buf(false, true)
    local opciones = {
        style = "minimal",
        border= "shadow",
        relative = "editor",
        width = 50,
        height = 90,
        row = 5,
        col =5,
        border = "single",
    }

    local win_id = vim.api.nvim_open_win(bufnr, true, opciones)
    vim.api.nvim_win_set_option(win_id, 'winhl', 'Normal:MyFloatBg')
    --Formateo salida con los saltos de linea:
    -- Puedes personalizar el contenido de la ventana
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,datos)
end

function obten_context(ruta)
    local archivo = io.open(ruta,'r') 
    local cadena = ""
    for linea in archivo:lines() do
        cadena = cadena .. ", " .. linea
    end
    archivo:close()
    return cadena
end
function save_context(cadena,ruta)
    local archivo = io.open(ruta,'a+')
    archivo:write(cadena .. "\n")
    archivo:close()
end
function remove_context(ruta)
    local archivo = io.open(ruta,"w+")
    archivo:close()
end
function input()
    --aqui cargo el promp y lo devuelvo

end
function M.app(param)
    vim.keymap.set('n','<C-'.. param["key"] .. '>',function()
        local context = ""
        local response = ""
        --aqui selecciono opcion de chat
        pickers.new({}, {
            prompt_title = "Indique si quiere mantener el contexto o prefiere iniciar un nuevo chat",
            finder = finders.new_table {
                results = {'new','context'}
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_,map)
                map('i',"<cr>",function (prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    response = (entry[1])
                    if (response == "context") then
                        --aqui debo obtener el contexto
                        context = obten_context(param['ruta_contexto'])
                    end
                    --aqui obtengo el promp para la consulta a gemini
                    vim.ui.input({prompt='Haga su consulta a Gemini: '},function(opt)
                        --aqui ejecuto la consulta http por curl con un script bash
                        promp = opt
                        solicitudHttp(opt,context,param['salida'],param['script_bash'])
                    end)
                    if (response == "new") then
                        --Aqui guardo el contexto en el archivo historia
                        remove_context(param['ruta_contexto'])
                    end
                    --guardo la ultima consulta en el contexto para futuros chat
                    save_context(promp,param['ruta_contexto'])

                end)
                return true
            end
        }):find()

    end,{noremap=true,silent=true})
end

return M
