#!/bin/bash

# PERFORMANTA GENERALA

# procentul de timp CPU utilizat de procesele din sistem

function procentTimpProcese 
{
    numar_cpu=$(nproc)
    cpu_folosit=$(ps -eo %cpu --sort=-%cpu | egrep -v "%CPU")
    cpu_total=0

    for linie in $cpu_folosit
    do 
        if [[ "$linie" =~ ^[0-9.]+$ ]]
        then 
            cpu_total=$(echo "$cpu_total + $linie" | bc)
        fi 
    done 

    cpu_total=$(echo "scale=2; $cpu_total / $numar_cpu" | bc)
    echo "Procentul total de utilizare a CPU de catre procesele din sistem este: $cpu_total%"
}

# cantitatea de memorie RAM utilizata si disponibila

function memorieRAM
{
    detalii_memorie=$(free -h | egrep -i mem | tr -s ' ')

    mem_totala=$(echo "$detalii_memorie" | cut -d' ' -f2)
    mem_folosita=$(echo "$detalii_memorie" | cut -d' ' -f3)
    mem_disponibila=$(echo "$detalii_memorie" | cut -d' ' -f4)

    echo "Informatii despre memoria RAM -> totala: $mem_totala, utilizata: $mem_folosita, disponibila: $mem_disponibila"
}

# numarul toatal de procese, procese care ruleaza, procese care asteapta sa fie rulate si load average

function detaliiProcese
{
    load_average=$(uptime | tr -s ' ' | cut -d":" -f5)
    numar_procese=$(ps -e --no-headers | wc -l)
    numar_procese_r=$(ps -eo stat --no-headers |  egrep "R" | wc -l)
    numar_procese_w=$(ps -eo stat --no-headers |  egrep "D|I" | wc -l)


    echo "Numar_procese: $numar_procese, numar_procese_running: $numar_procese_r, numar_procese_waiting: $numar_procese_w, Load_average: $load_average"
}

# cantitatea de spatiu pe disk utilizat si disponibil pentru partitiile sistemului

function spatiuDisk
{
    du_folosit=$(df | egrep "/dev/sd" | tr -s ' ' | cut -d ' ' -f3)
    du_disponibil=$(df | egrep "/dev/sd" | tr -s ' ' | cut -d ' ' -f4)

    total_folosit=0
    total_disponibil=0

    for du_fol in $du_folosit
    do 
        total_folosit=$(echo "$total_folosit + $du_fol" | bc)
    done

    for du_disp in $du_disponibil
    do 
        total_disponibil=$(echo "$total_disponibil + $du_disp" | bc)
    done

    echo "Disk_usage_folosit: $total_folosit, disk_usage_disponibil: $total_disponibil"
}

# rate de citire si scriere a discurilor

function rateCitireScriere
{
    rata_citire=$(iostat | tail -n +7 | tr -s ' ' | cut -d' ' -f3 | tr "," ".")
    rata_scriere=$(iostat | tail -n +7 | tr -s ' ' | cut -d' ' -f4 | tr "," ".")

    total_citire=0
    total_scriere=0

    for rc in $rata_citire
    do 
        if [[ "$rc" =~ ^[0-9.]+$ ]]
        then
            total_citire=$(echo "$total_citire + $rc" | bc)
        fi 
    done 

    for rs in $rata_scriere
    do 
        if [[ "$rs" =~ ^[0-9.]+$ ]]
        then
            total_scriere=$(echo "$total_scriere + $rs" | bc)
        fi 
    done 

    echo "rata_citire_disk: $total_citire kB_read/s, rata_scriere_disk: $total_scriere kB_wrtn/s"
}



echo "  Performanta generala:"
echo 
procentTimpProcese
memorieRAM
detaliiProcese
spatiuDisk
rateCitireScriere

