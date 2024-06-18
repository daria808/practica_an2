# practica_an2
Tool monitorizare sisteme linux prin SSH și centralizare

# 17.06.2024
README modificat pentru test

modificare noua

# 18.06.2024

1. Am instalat ssh pe LinuxMint si pe Ubuntu, folosind comanda: "sudo apt-get install openssh-server"
2. Am creat in VirtualBox o retea NAT, apoi am configurat ca fiecare masina virtuala sa aiba NAT Network
3. Am generat o pereche de chei folosind comanda: "ssh-keygen -t rsa -b 4096"
4. Am configurat conectarea LinuxMint - Ubuntu folosind: "ssh-copy-id daria@10.0.2.15", unde "daria" e numele utilizatorului de pe Ubuntu si adresa IP este tot adresa de pe Ubuntu
5. M-am conectat de pe masina sursa pe masina tinta (LinuxMint -> Ubuntu) folosind: "ssh daria@10.0.2.15


