 require('io')
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local conf = require("telescope.config").values

function tipo_proyecto(proyecto_nombre)
    
    ---------------------------------------------------------------------
    pickers.new({}, {
        prompt_title = "Seleccione que tipo de proyecto quiere crear",
        finder = finders.new_table {
          results = { 'Laravel', 'Vue', 'Html_general','Blanco' }
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_,map)
            map('i',"<cr>",function (prompt_bufnr)
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                local choice = (entry[1]) --aqui choice es el string que devulve la seleccion
                local ruta = "/opt/lampp/htdocs/"
                 if choice == "Laravel"  then
                    vim.api.nvim_command ('!composer create-project --prefer-dist laravel/laravel ' .. ruta .. proyecto_nombre) 
                elseif choice == "Vue" then
                    vim.api.nvim_set_current_dir(ruta)
                    vim.api.nvim_command ('!vue create -d '.. proyecto_nombre )
                    vim.api.nvim_command ('!npm install')
                elseif choice == "Blanco" then
                    vim.api.nvim_command ('!mkdir ' .. ruta .. proyecto_nombre ..'/')
                else
                    vim.api.nvim_command ('!mkdir ' .. ruta .. proyecto_nombre ..'/')
                    vim.api.nvim_command ('!touch ' .. ruta .. proyecto_nombre ..'/index.html')
                end           
            end)
            return true
        end
      }):find()

end

function crear(nombre)
    cargar = true
    archivo = io.open('/home/ariel/.config/nvim/proyectos_plug/proyectos/lua/proyectos/listas.txt','a+')
    for linea in archivo:lines() do
        if nombre == linea then
           cargar = false
        end
    end
    if cargar then
       archivo:write(nombre .. '\n')
    end
    archivo:close()
    tipo_proyecto(nombre)
    return cargar
end

function leer()
    datos = {}
    archivo = io.open('/home/ariel/.config/nvim/proyectos_plug/proyectos/lua/proyectos/listas.txt','r')
    for linea in archivo:lines() do
        table.insert(datos,linea)
    end
    archivo:close()
    return datos
end


function cargar_proyectos(nombre)
    --set de patch
   vim.api.nvim_command("set path+=/opt/lampp/htdocs/".. nombre .."/")
   --cambio el directorio
   vim.api.nvim_command("cd /opt/lampp/htdocs/".. nombre .."/")
    --abrir el directorio de trabajo
   vim.api.nvim_command("e /opt/lampp/htdocs/".. nombre .. "/")
   vim.g.proyecto = nombre
   if not os.rename("/home/ariel/mysqld.sock","/home/ariel/mysqld.sock") then
       vim.api.nvim_command("!ln -s /opt/lampp/var/mysql/mysql.sock /home/ariel/mysqld.sock")
   end
end


----------------------------------------------------------------------------------------------------------------------
local M = {}
function crear_proyecto()
   vim.ui.input({prompt="Indique nombre del proyecto a crear:"},function (input)
       salida = crear(input) 
       if salida == false then
           print("El proyecto ya existe por lo que no fue creado")
       else
           print("Proyecto creado") 
       end
   end) 
end

function levantar_proyecto2()
   proyectos = leer()
  pickers.new({}, {
    prompt_title = "seleccione un proyecto",
    finder = finders.new_table {
      results = proyectos
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_,map)
        map('i',"<cr>",function (prompt_bufnr)
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            local choice = (entry[1])
            cargar_proyectos(choice)

        end)
        return true
    end
  }):find()
end

function menu()

  pickers.new({}, {
    prompt_title = "seleccione que quiere hacer",
    finder = finders.new_table {
      results = { 'crear_proyecto','abrir_proyecto','eliminar proyecto' }
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_,map)
        map('i',"<cr>",function (prompt_bufnr)
            actions.close(prompt_bufnr)
            local entry = action_state.get_selected_entry()
            local choice = (entry[1])
            if choice == 'crear_proyecto' then
                crear_proyecto() 
            elseif choice == 'abrir_proyecto' then
                levantar_proyecto2()
            else
            vim.api.nvim_command('e /home/ariel/.config/nvim/proyectos_plug/proyectos/lua/proyectos/listas.txt')
    end

        end)
        return true
    end
  }):find()

end
function M.app(opt)
    vim.keymap.set('n','<C-'..opt['key'] ..'>',function()
        menu()        			
    end,{noremap=true,silent=true})
end

return M


