#!/bin/bash

filename="$1"
touch "$filename"
echo "Statistici:" > "$filename"
echo >> "$filename"

# PERFORMANTA GENERALA

# procentul de timp CPU utilizat de procesele din sistem

function procentTimpProcese 
{
    numar_cpu=$(nproc)
    cpu_folosit=$(ps -eo %cpu --sort=-%cpu | grep -vE "%CPU")
    cpu_total=0

    for linie in $cpu_folosit
    do 
        if [[ "$linie" =~ ^[0-9.]+$ ]]
        then 
            cpu_total=$(echo "$cpu_total + $linie" | bc)
        fi 
    done 

    cpu_total=$(echo "scale=2; $cpu_total / $numar_cpu" | bc)
    echo "Procentul total de utilizare a CPU de catre procesele din sistem este: $cpu_total%" >> "$filename"
}

# cantitatea de memorie RAM utilizata si disponibila

function memorieRAM
{
    detalii_memorie=$(free -h | grep -iE mem | tr -s ' ')

    mem_totala=$(echo "$detalii_memorie" | cut -d' ' -f2)
    mem_folosita=$(echo "$detalii_memorie" | cut -d' ' -f3)
    mem_disponibila=$(echo "$detalii_memorie" | cut -d' ' -f4)

    echo "Informatii despre memoria RAM -> totala: $mem_totala, utilizata: $mem_folosita, disponibila: $mem_disponibila" >> "$filename"
}

# numarul toatal de procese, procese care ruleaza, procese care asteapta sa fie rulate si load average

function detaliiProcese
{
    load_average=$(uptime | tr -s ' ' | cut -d":" -f5)
    numar_procese=$(ps -e --no-headers | wc -l)
    numar_procese_r=$(ps -eo stat --no-headers |  grep -E "R" | wc -l)
    numar_procese_w=$(ps -eo stat --no-headers |  grep -E "D|I" | wc -l)


    echo "Numar_procese: $numar_procese, numar_procese_running: $numar_procese_r, numar_procese_waiting: $numar_procese_w, Load_average: $load_average" >> "$filename"
}

# cantitatea de spatiu pe disk utilizat si disponibil pentru partitiile sistemului

function spatiuDisk
{
    du_folosit=$(df | grep -E "/dev/sd" | tr -s ' ' | cut -d ' ' -f3)
    du_disponibil=$(df | grep -E "/dev/sd" | tr -s ' ' | cut -d ' ' -f4)

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

    echo "Disk_usage_folosit: $total_folosit, disk_usage_disponibil: $total_disponibil" >> "$filename"
}

# rate de citire si scriere a discurilor

function rateCitireScriere
{
    # pentru "iostat" am nevoie de bibliotecta "sysstat"
    if ! command -v iostat &> /dev/null
    then
        echo "sysstat nu este instalat. Instalare..." >> "$filename"

        sudo apt-get update
        sudo apt-get install sysstat -y
    fi

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

    echo "rata_citire_disk: $total_citire kB_read/s, rata_scriere_disk: $total_scriere kB_wrtn/s" >> "$filename"
}



echo "  Performanta generala:" >> "$filename"
echo >> "$filename"
procentTimpProcese
memorieRAM
detaliiProcese
spatiuDisk
rateCitireScriere



# RESURSE DE SISTEM

# procese active, utilizare memorie si cpu a fiecarui proces

function infoProcese
{
    echo "Utilizarea CPU si memorie a fiecarui proces:" >> "$filename"
    ps -eo pid,%cpu,%mem --sort=-%cpu | head -n 20 >> "$filename"
    echo >> "$filename"
}

# cantitatea de trafic trimisa si primita

function traficTransmisPrimit
{
    pachete_primite=$(grep -E "enp0s3" /proc/net/dev | tr -s " " | cut -d" " -f3)
    pachete_trimise=$(grep -E "enp0s3" /proc/net/dev | tr -s " " | cut -d" " -f10)

    echo "Pachete trimise: $pachete_trimise, pachete primite: $pachete_primite" >> "$filename"
    
}

# numarul de conexiuni de retea active

function conexiuniActive
{
    numar_conexiuni=$(ss -s | head -n1 | cut -d" " -f2)

    echo "Numarul de conexiuni active: $numar_conexiuni" >> "$filename"
}


echo >> "$filename"
echo "  Resurse de sistem:" >> "$filename"
echo >> "$filename"
infoProcese
traficTransmisPrimit
conexiuniActive


# SECURITATE

# activitatea sistemului si mesajele de eroare

function jurnaleSistem
{
    jurnal=$(journalctl -n 10)
    echo "Ultimele 10 intrari in jurnalul de sistem:" >> "$filename"
    echo "$jurnal" >> "$filename"
}

# conexiunile active din retea

function conexiuniRetea
{
    if ! command -v netstat &> /dev/null
    then
        echo "netstat nu este instalat. Instalare..." >> "$filename"

        sudo apt-get update
        sudo apt-get install -y net-tools
    fi 

    conex=$(netstat -tuln)
    echo >> "$filename"
    echo "Conexiuni active:" >> "$filename"
    echo "$conex" >> "$filename"
    echo >> "$filename"
}

# detalii din jurnalul de autentificare

function jurnalAuth
{
    jurnAuth=$(tail -n 10 /var/log/auth.log)
    echo >> "$filename"
    echo "Ultimele 10 mesaje din jurnalul de autentificare auth.log" >> "$filename"
    echo "$jurnAuth" >> "$filename"
    echo >> "$filename"
}

# calculez sumele de control a fisierelor din directorul curent

function sumeControl
{
    if [ ! -f "sumeInitiale" ]
    then
        find . -type f -exec sha256sum {} + > sumeInitiale
    fi 

    find . -type f -exec sha256sum {} + > sumeVerificare

    
    if cmp -s "sumeInitiale" "sumeComparare"
    then
        echo "Fisierele din sistem NU sunt modificate!" >> "$filename"
    else
        echo "Fisierele din sistem sunt modificate!" >> "$filename"
    fi
}


echo >> "$filename"
echo "  Securitate:" >> "$filename"
echo >> "$filename"
jurnaleSistem
conexiuniRetea
sumeControl


# APLICATII SPECIFICE -> voi verifica detalii despre aplicatia VisualStudioCode disponibila pe cele doua
# sisteme linux care participa la testari

# performanta aplicatiei

function performantaApp
{
    vsc_procese=$(pgrep -c -x code | wc -l)

    if ! command -v top &> /dev/null
    then
        echo "top nu este instalat. Instalare..." >> "$filename"

        sudo apt-get update
        sudo apt-get install procps -y
    fi 

    folosirecpu=$(top -b -n 1 | grep -E "code$" | tr -s " " | cut -d" " -f10 | tr "," ".")

    if [ -z "$folosirecpu" ]; then
        echo "Nu există procese code în executie!" >> "$filename"
    else
        totalcpu=0
        for folcpu in $folosirecpu
        do 
            if [[ "$folcpu" =~ ^[0-9.]+$ ]]
            then
                totalcpu=$(echo "$totalcpu + $folcpu" | bc)
            fi
        done 
        echo "Gradul de folosire cpu de catre vsc: $totalcpu%" >> "$filename"
    fi 

    echo "Numarul de procese vsc: $vsc_procese" >> "$filename"
}

# verific daca aplicatia e in executie

function verificaExecutie
{
    if pgrep -x "code" > /dev/null
    then 
        echo "Visual Studio Code este in executie!" >> "$filename"
    else 
        echo "Visual Studio Code NU este in executie!" >> "$filename"
    fi 
}

echo >> "$filename"
echo "  Performanta aplicatiei:" >> "$filename"
echo >> "$filename"
performantaApp
verificaExecutie


# DIVERSE

function infoExtra
{
    ultimiiUtilizatori=$(last | head -n -2 | tr -s " " | cut -d " " -f1| sort | uniq -c | tr -s " " | cut -d" " -f3)
    echo "Ultimii utilizatori conectati sunt:" >> "$filename"
    echo "$ultimiiUtilizatori" >> "$filename"

    utilCurent=$(whoami)
    echo "Utilizatorul conectat in acest moment: $utilCurent" >> "$filename"
}

function afiseazaInode
{
    inoduri=$(ls -li | tail -n +2 | cut -d " " -f1 | tr "\n" ",")
    echo "Inodurile fisierelor din directorul curent: $inoduri" >> "$filename"
}

function hardlinks_softlinks
{
    numar_hardlinks=$(find / -maxdepth 1 -type f -links +1 -o -type d -links +1 2>/dev/null | wc -l)
    echo "Numarul de hardlink-uri din sistem: $numar_hardlinks" >> "$filename"

    numar_softlinks=$(find / -maxdepth 1 -type l 2>/dev/null | wc -l)
    echo "Numarul de softlink-uri din sistem: $numar_softlinks" >> "$filename"
}

echo >> "$filename"
echo "  Informatii extra:" >> "$filename"
echo >> "$filename"
infoExtra
afiseazaInode
hardlinks_softlinks

#cat "$filename"