#!/bin/bash
PROMP=$1
CONTEXTO=$2
RUTA=$3
API_KEY="AIzaSyDZ_wp4icyc_3e2NpudiRMcF9zqgaC4aoY"
echo "${PROMP}" 
data=$(curl \
    -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${API_KEY} \
    -H 'Content-Type: application/json' \
    -d @<(echo '{
    "contents": [
    {
        "parts": [
        {
            "text":"input:'+"${PROMP}"+'"
        },
        {
            "text":"context:'+"${CONTEXTO}"+'"
        },
        {
            "text": "output: "
        }
        ]
    }
    ],
    "generationConfig": {
    "temperature": 1,
    "topK": 64,
    "topP": 0.95,
    "maxOutputTokens": 8192,
    "stopSequences": []
},
"safetySettings": [
{
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
},
{
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
},
{
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
},
{
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
}
]
}'))
echo "$data" | while IFS= read -r linea; do
if [[ ${linea:13:4} == 'text' ]]; then
    longitud=${#linea} 
    salida=${linea:19:longitud-19} 
#aqui tengo la salida con la respuesta sin formatear
#A continuacion formateo la salida y la almaceno en un archivo
    salida2=$(echo -e "$salida" | sed 's/\\//g' | sed 's/\\n/\n/g' | sed 's/\\++\\/++/g') 
    echo "$salida2" > "$RUTA"
  fi
done 

