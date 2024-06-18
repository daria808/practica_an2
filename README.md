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


Am creat scriptul cu numele monitor.sh
Scriptul va urmari mai multe categorii mari pentru monitorizare, care vor avea subcategorii.

I. Performanta generala a sistemului

1) procentul de timp CPU utilizat de procesele din sistem
- am creat functia "procentTimpProcese" care va calcula valoarea totala a CPU consumata de catre procesele sistemului
- pe scurt, am retinut intr-o variabila numarul de nuclee, apoi am retinut in alta variabila toate valorile CPU ale tuturor proceselor din sistem. In final am adunat toate valorile CPU si le-am impartit la numarul de nuclee pentru aflarea procesului total.

2) cantitatea de memorie RAM utilizata si disponibila
- am retinut toate detaliile despre memorie intr-o variabila, apoi am extras ce aveam nevoie folosind comenzile "echo" respectiv "cut".

3) numarul toatal de procese, procese care ruleaza, procese care asteapta sa fie rulate si load average
- pe acelasi principiu ca mai sus, am retinut procesele (fara header) intr-o variabila, apoi am distribuit valorile de care am avut nevoie in alte variabile, iar pentru *load average* am folosit comenzile "uptime", "tr" si "cut".

4) cantitatea de spatiu pe disk utilizat si disponibil pentru partitiile sistemului
- am retinut "disk usage folosit" respectiv "disponibil" in variabile, apoi am iterat prin aceste variabile folosind cate un *for* pentru a calcula totalul in ambele cazuri.

5) rate de citire si scriere a discurilor
- am extras ratele de citire si scriere folosind comanda "iostat" apoi am facut similar cu ce am facut la 4), am iterat prin variabile si am calculat totalul.


!! Testarile le-am facut folosind comanda: "ssh daria@10.0.2.15 'bash -s' < monitor.sh" pentru a obtine rezultatele de pe Ubuntu. ("bash -s" este folosit pentru a rula scriptul primit ca parametru la stdin pe masina tinta)