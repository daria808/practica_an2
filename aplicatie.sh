#!/bin/bash

# comenzi pentru ubuntu

ubuntu_pass=$(sudo cat /home/daria/parole_vms | grep -E "ubuntu" | cut -d":" -f2)
sshpass -p "$ubuntu_pass" scp plot.py daria@10.0.2.15:
sshpass -p "$ubuntu_pass" ssh daria@10.0.2.15 'bash -s' < ./monitor.sh ubuntu_stats plot "$ubuntu_pass"
sshpass -p "$ubuntu_pass" scp daria@10.0.2.15:grafic.png .
sshpass -p "$ubuntu_pass" ssh daria@10.0.2.15 'cat ubuntu_stats' > statistici
sshpass -p "$ubuntu_pass" ssh daria@10.0.2.15 'cat pachete' > pachete
mv grafic.png grafic_ubuntu.png


#comenzi pentru kali

kali_pass=$(sudo cat /home/daria/parole_vms | grep -E "kali" | cut -d":" -f2)
sshpass -p "$kali_pass" scp plot.py daria@10.0.2.5:
sshpass -p "$kali_pass" ssh daria@10.0.2.5 'bash -s' < ./monitor.sh kali_stats plot "$kali_pass"
sshpass -p "$kali_pass" scp daria@10.0.2.5:grafic.png .
sshpass -p "$kali_pass" ssh daria@10.0.2.5 'cat kali_stats' >> statistici
sshpass -p "$kali_pass" ssh daria@10.0.2.5 'cat pachete' >> pachete
mv grafic.png grafic_kali.png