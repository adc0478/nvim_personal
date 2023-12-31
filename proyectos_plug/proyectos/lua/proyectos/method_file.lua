 require('io')
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
function cargar_proyecto(nombre)

end
