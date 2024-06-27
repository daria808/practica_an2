#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "Scriptul are nevoie de 2 parametri (id_user@ip si numele masinii tinta)."
    exit 1
fi

nume_ip="$1"
masina_tinta="$2"

pass=$(sudo cat /home/daria/parole_vms | grep -E "$masina_tinta" | cut -d":" -f2)
sshpass -p "$pass" scp plot.py "$nume_ip":~/
sshpass -p "$pass" ssh "$nume_ip" 'bash -s' < ./monitor.sh "$masina_tinta"_stats plot "$pass"
sshpass -p "$pass" scp "$nume_ip":grafic.png .
sshpass -p "$pass" ssh "$nume_ip" "cat ${masina_tinta}_stats" >> statistici
sshpass -p "$pass" ssh "$nume_ip" 'cat pachete' >> pachete
mv grafic.png grafic_$masina_tinta.png