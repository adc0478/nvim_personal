local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local M = {}
function solicitudHttp(promp,contexto,salida,script_bash)
    local parametros = "'".. promp .. "' '" .. contexto .. "' '" .. salida .. "'"
    vim.api.nvim_command('!'..script_bash .. " " ..  parametros)
end
function procesar_salida(salida)

    local tabla = {}
    local archivo = io.open(salida,"r")
    for linea in archivo:lines() do
        table.insert(tabla,linea)
    end
    archivo:close()
    return tabla
end

function guardar_historia(data,file_historia)
    local temporal ={}
    --abrir el archivo de historia en lectura
    local archivo = io.open(file_historia,'r')

    --recorrer a partir del segundo item almacenando en una tabla (temporal)
    inter = archivo:read()
    for linea in archivo:lines() do
        if (linea == '####') then
           table.insert(temporal,linea)
           break
        end
    end
    for linea_f in archivo:lines() do
       table.insert(temporal,linea_f)
    end
    --cerrar el archivo

    archivo:close()
    --abrir el archivo en escritura W y cargar todas las lineas almacenadas en la tabla (temporal)
     archivo = io.open(file_historia,'w')
     
    --recorrer data para almacenar la ultima respuesta
    for index,valor in pairs(temporal) do
        archivo:write(valor .. "\n")
    end
    archivo:write("####" .. "\n")
    for idx,valor2 in pairs(data) do
        archivo:write(valor2 .. "\n")
    end
    --cerrar el archivo y guardar
    archivo:close()
end
function listar_historia(file_historia)
    --abrir el archivo historia en R lectura
    archivo = io.open(file_historia,"r")

    --recorrer el archivo almacenando en la tabla (lectura) solo la primera linea de cada respuesta y el indice de cada una de esas lineas
    local data = {}
    for linea in archivo:lines() do
        if (linea == "####") then
            table.insert(data,archivo:read())
        end
    end
    --cerrar archivo y retornar la listas (lectura)
    archivo:close()
    return data
end
function ventana_lista_historial(lista,file_historia)
   --con telescope visualizar la lista de historial
    pickers.new({}, {
            prompt_title = "Seleccione el chat a visualizar",
            finder = finders.new_table {
                results = lista
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_,map)
                map('i',"<cr>",function (prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    response = (entry[1])
   --accion que ejecute obtener_historia para visualizar historia seleccionada
                    obtener_historia(response,file_historia)
                end)
                return true
            end
        }):find()

end
function obtener_historia(indice,file_historia)
        local leer = false
        local data = {}
    --abrir el archivo historia y empezar a leer desde el indice
        archivo = io.open(file_historia,"r")
    --recorrer el archivo levantando la respuesta en una tabla (respuesta)
        for linea in archivo:lines() do

            if (linea == indice and leer == false) then
                leer = true
            end
            if (leer == true and linea ~= "####") then

                table.insert(data,linea)
            end
            if (leer == true and linea == "####") then
                break
            end
        end
        archivo:close()
    --cerrar archivo y ejecutar crear_ventana(respuesta)
    crear_ventana(data)
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
                results = {'new','context','anteriores'}
            },
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_,map)
                map('i',"<cr>",function (prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local entry = action_state.get_selected_entry()
                    response = (entry[1])
                    if (response == "anteriores") then
                            local lista = listar_historia(param['historia'])
                            ventana_lista_historial(lista,param['historia'])
                        else
                            if (response == "context") then
                                --aqui debo obtener el contexto
                                context = obten_context(param['ruta_contexto'])
                            end
                            --aqui obtengo el promp para la consulta a gemini
                            vim.ui.input({prompt='Haga su consulta a Gemini: '},function(opt)
                                --aqui ejecuto la consulta http por curl con un script bash
                                promp = opt
                                solicitudHttp(opt,context,param['salida'],param['script_bash'])
                                local tabla = procesar_salida(param['salida'])
                                guardar_historia(tabla,param['historia'])
                                crear_ventana(tabla)
                            end)
                            if (response == "new") then
                                --Aqui guardo el contexto en el archivo historia
                                remove_context(param['ruta_contexto'])
                            end
                            --guardo la ultima consulta en el contexto para futuros chat
                            save_context(promp,param['ruta_contexto'])
                    end
                end)
                return true
            end
        }):find()

    end,{noremap=true,silent=true})
end

return M
