#!/bin/bash

# -----------------------------------------------------------------------------------------------------------------
# Este script convierte códigos ASCII (en decimal) a su representación textual.
# Puede recibir una cadena contínua de números (ej: "72101108"j) o códigos separados (ej: 72 101 108).
# Uso:
# ./ascii_converter.sh 72101108
# ./ascii_converter.sh 72 101 108
# -----------------------------------------------------------------------------------------------------------------

# $# -> número de argumentos pasados al script
# $0 -> nombre del script ejecutado

# Si no se pasa ningún argumento, mostramos ayuda y salimos
if [ $# -eq 0 ]; then
  echo "Uso: $0 cadena_assci o $0 codigo1 [codigo2...]"
  echo "Ejemplos: "
  echo "  $0 72 101 080"
  echo "  $0 72101080"
  exit 1
fi

# -----------------------------------------------------------------------------------------------------------------
# MODO 1: Cadena contínua (sin espacios)
# - $# -eq 1 -> hay un solo argumento
# - [[ ! "$1" =~ [[:space:]] ]] -> el argumento no contiene espacios, tabulaciones, etc.
# - =~ -> operador de comparación de expresiones regulares (regex)
# - [[:space:]] -> clase POSIX que representa cualquier carácter de espacio
# -----------------------------------------------------------------------------------------------------------------
if [ $# -eq 1 ] && [[ ! "$1" =~ [[:space:]] ]]; then
  input="$1"
  output=""
  pos=0
  length=${#input} # ${#var} devuelve la longitud de una cadena

  # Recorremos la cadena tomando grupos de 3 o 2 dígitos
  while [ $pos -lt $length ]; do 
    code3=${input:$pos:3} # Tomamos 3 caracteres desde la posición actual (0)
	
	# Validamos que code3 sea un número de 3 cifras y menor o igual a 255
	# - ${#code3} -> longitud de la subcadena
	# - -le -> "less or equal" (menor o igual que)
	# - 2>/dev/null -> redirige errores a null (por si no es número)
    if [[ ${#code3} -eq 3 && "$code3" -le 255 ]] 2>/dev/null; then
      code=$code3
      pos=$(($pos+3)) # Avanzamos 3 posicones
    else
      code2=${input:$pos:2} # Tomamos solo 2 caracteres
      code=$code2
      pos=$(($pos+2)) # Avanzamos 2 posiciones
    fi

    # Convertimos el código decimal a octal -> ASCII
	# - printf '%03o' -> convierte a octal con 3 cifras (relleno con ceros izquierda)
	# - $((10#$code)) -> Fuerza la interpretación decimal (evita errores con ceros iniciales)
	# - \\ -> escape doble para que el printf externo lea como carácter
    output+=$(printf "\\$(printf '%03o' $((10#$code)))")
  
  done

  echo "$output"
  
# -----------------------------------------------------------------------------------------------------------------
# MODO 2: Argumentos separados (cadda uno un código ASCII decimal)
# -----------------------------------------------------------------------------------------------------------------
else
  for code in "$@"; do
  printf "\\$(printf '%03o' $((10#$code)))"
  done
  echo 
fi
