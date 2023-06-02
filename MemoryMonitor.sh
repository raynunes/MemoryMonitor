#!/bin/bash

# Script: Monitora a memória do servidor e ao chegar num limite específco executa um comando.
# Autor: Cesar Nunes | raynunes@gmail.com


command_to_execute="service apache2 restart"
log_file="log.txt"

while true; do
    mem_info=$(free -m | grep Mem)
    total_mem=$(echo $mem_info | awk '{print $2}')
    used_mem=$(echo $mem_info | awk '{print $3}')
    free_mem=$(echo $mem_info | awk '{print $4}')
    percent_used=$(echo "scale=2; $used_mem / $total_mem * 100" | bc)

    echo "Total de memória: $total_mem MB"
    echo "Memória usada: $used_mem MB"
    echo "Memória livre: $free_mem MB"
    echo "Porcentagem de memória usada: ${percent_used}%"

    if (( $(echo "$percent_used >= 65" | bc -l) )); then
        echo "Consumo de memória atingiu 65%!"
        echo "Executando o comando: $command_to_execute"
        $command_to_execute

        log_message="$(date +'%Y-%m-%d %H:%M:%S'): Comando executado: $command_to_execute"
        echo "$log_message" >> "$log_file"
    fi

    sleep 5
done
