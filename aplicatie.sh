#!/bin/bash

# comenzi pentru ubuntu

ubuntu_pass=$(sudo cat /home/daria/parole_vms | grep -E "ubuntu" | cut -d":" -f2)
scp plot.py daria@10.0.2.15:
ssh daria@10.0.2.15 'bash -s' < ./monitor.sh ubuntu_stats plot
scp daria@10.0.2.15:grafic.png .
mv grafic.png grafic_ubuntu.png


#comenzi pentru kali

kali_pass=$(sudo cat /home/daria/parole_vms | grep -E "kali" | cut -d":" -f2)
scp plot.py daria@10.0.2.5:
ssh daria@10.0.2.5 'bash -s' < ./monitor.sh kali_stats plot
scp daria@10.0.2.5:grafic.png .
mv grafic.png grafic_kali.png