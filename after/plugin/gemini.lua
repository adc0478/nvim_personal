opt ={
    key = 'b',
    salida = '/home/ariel/.config/nvim/proyectos_plug/gemini/respuesta.txt',
    historia = '/home/ariel/.config/nvim/proyectos_plug/gemini/historia.txt',
    script_bash = '/home/ariel/.config/nvim/proyectos_plug/gemini/gemini.sh',
    ruta_contexto = '/home/ariel/.config/nvim/proyectos_plug/gemini/contexto.txt'
}
require('gemini').app(opt)
--salida es el archivo donde se almacena la respuesta formateada
