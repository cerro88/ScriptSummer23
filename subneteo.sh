#!/bin/bash

#intento de script para hacer subneteo

# Función para calcular las subredes
calcular_subredes(){
  direccion_ip=${1}
  mascara=${2}
  num_subredes=${3}

  # Separar la dirección IP y la máscara en octetos
  IFS='.' read -r -a ip_octetos <<< "${direccion_ip}"
  IFS='.' read -r -a mascara_octetos <<< "${mascara}"

  # Calcular el número de bits de host en la máscara
  num_bits_host=0
  for octeto in "${mascara_octetos[@]}" 
  do
    bits_octeto=$(echo "obase=2; ${octeto}" | bc)
    num_bits_host=$((num_bits_host + $(echo -n "${bits_octeto}" | grep -o "1" - <<< "" | wc -l)))
  done
  # Calcular el número de subredes disponibles
  num_subredes_disponibles=$((2 ** num_bits_host))

  if (( num_subredes > num_subredes_disponibles ))
  then
    echo "Error: El número de subredes solicitadas excede el número de subredes disponibles con la máscara especificada."
    exit 1
  fi
  # Calcular el tamaño de cada subred
  size_subred=$(echo "scale=0"; num_subredes_disponibles / num_subredes | bc )
  # Calcular las subredes
  direccion_red="${ip_octetos[0]}.${ip_octetos[1]}.${ip_octetos[2]}"
  host=0

  for (( i = 0; i < num_subredes; i++ )); do
    # Calcular la dirección de red de la subred actual
    subred="${direccion_red}.${host}"

    # Calcular la dirección de broadcast de la subred actual
    broadcast_octeto=$((host + size_subred - 1))
    broadcast="${direccion_red}.${broadcast_octeto}"

    # Incrementar el host para la próxima subred
    host=$((host + size_subred))

    # Imprimir los resultados de la subred actual
    echo "Subred $((i+1)):"
    echo "Dirección de red: ${subred}"
    echo "Dirección de broadcast: ${broadcast}"
    echo
  done
}

# Obtener la dirección IP, la máscara de subred y el número de subredes del usuario
direccion_ip=${1}
mascara=${2}
num_subredes=${3}

# Llamar a la función de cálculo de subredes
calcular_subredes "${direccion_ip}" "${mascara}" "${num_subredes}"

#más errores que antes