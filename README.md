# practica_an2
Tool monitorizare sisteme linux prin SSH și centralizare

# Cerinte

1. Pregatesc mediul de comunicare prin ssh dintre cele doua masini virtuale.
2. Extragere detalii despre performanta generala a sistemului tinta, precum:
    a. procentul de timp CPU utilizat de procesele din sistem
    b. cantitatea de memorie RAM utilizata si disponibila
    c. numarul toatal de procese, procese care ruleaza, procese care asteapta sa fie rulate si load average
    d. cantitatea de spatiu pe disk utilizat si disponibil pentru partitiile sistemului
    e. rate de citire si scriere a discurilor
3. Extragere detalii despre resursele sistemului tinta.
    a. procese active, utilizare cpu si memorie a fiecarui proces
    b. cantitatea de tarfic transmisa si primita
    c. numarul de conexiuni de retea active
4. Extragere date despre securitate.
    a. ultimele n intrari din jurnalul de sistem
    b. conexiunile active din retea
    c. detalii din jurnalul de autentificare
    d. sumele de control ale fisierelor din directorul curent
5. Extragere detalii despre o aplicatie specifica.
6. Extragere detalii generale despre sistem (ex. ultimii utilizatori conectati, utilizatorul curent).
    - afisare lista inode-urilor fisierelor din directorul curent
    - afisare numar hardlinks si softlinks din sistem
7. Salvarea datelor despre masinile virtuale monitorizate intr-un fisier specific.
8. Trimiterea rezultatului specific fiecarei masini virtuale pe aceasta, prin ssh.
9. Modificare astfel incat conectarea prin ssh sa fie facuta folosind parola sistemului linux.
10. Creare grafic cu date obtinute din monitorizare pentru fiecare sistem linux.

# 17.06.2024
README modificat pentru test
Modificare noua

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
- verific daca exista comanda "iostat", iar daca nu, instalez pachetul sysstat folosind comanda: "sudo apt-get install sysstat -y" (-y raspunde automat cu yes la intrebarile legate de instalare)
- am extras ratele de citire si scriere folosind comanda "iostat" apoi am facut similar cu ce am facut la 4), am iterat prin variabile si am calculat totalul.


!! Testarile le-am facut folosind comanda: "ssh daria@10.0.2.15 'bash -s' < monitor.sh" pentru a obtine rezultatele de pe Ubuntu. ("bash -s" este folosit pentru a rula scriptul primit ca parametru la stdin pe masina tinta)

# 19.06.2024

II. Resurse ale sistemului

1) procese active, utilizare cpu si memorie a fiecarui proces
- extrag informatiile necesare folosind comanda "ps"

2) cantitatea de tarfic transmisa si primita
- extrag aceste informatii din fisierul "/proc/net/dev"

3) numarul de conexiuni de retea active
- in acest caz folosesc comanda "ss -s"

III. Securitate

1) ultimele n intrari din jurnalul de sistem
- folosesc comanda journalctl

2) conexiunile active din retea
- in acest caz folosesc comanda "netstat -tuln" ( t-> TCP, u -> UDP, l -> listening, n -> adresa ip si porturi)

3) detalii din jurnalul de autentificare
- extrag datele din "/var/log/auth.log"

4) sumele de control ale fisierelor din directorul curent
- am doua fisiere: "sumeInitiale", respectiv "sumeVerificare"
- verific daca fisierul "sumeInitiale" exista, iar in caz contrar il creez calculand sumele de control din directorul curent folosind comanda "sha256sum"
- compar cele doua fisiere, "sumeInitiale" si "sumeVerificare" pentru a vedea daca s-au efectuat modificari asupra lor

IV. Aplicatii specifice

1) verific anumite detalii despre aplicatia Visual Studio Code
- am calculat numarul de procese vsc
- am verificat daca exista pe sistem comanda "top", in cazul in care nu exita o instalez
- am calculat cat timp cpu consuma aceasta aplicatie

2) verific daca aplicatia este in executie
- in acest caz folosesc comanda: 'pgrep -x "code"'.

V. Diverse
1) afisez ultimii utilizatori care au fost conectati pe sistem folosind comanda "last"

2) afisez utilizatorul conectat in momentul respectiv folosind comanda: "whoami"

# 20.06.2024

1. Am modificat pe masina tinta si pe masina gazda fisierul /etc/ssh/sshd_config, astfel incat sa am urmatoarele campuri decomentate sau adaugate astfel:
    * PubkeyAuthentication no
    * PasswordAuthentication yes

    Aceste modificari au fost necesare pentru a ma conecta prin ssh folosind parola

2. Am instalat inca o masina virtuala in Virtual Box si am configurat-o astfel incat sa ma pot conecta de pe LinuxMint pe aceasta folosind ssh.

3. Am creat un nou script prin intermediul caruia ma voi conecta la masinile tinta pentru a le monitoriza. Voi salva rezultatele monitorizarii intr-un fisier salvat in directorul curent al masinii tinta.

# 21.06.2024

1. Am scris scriptul "plot.py". Acesta se ocupa de crearea unui grafic pe baza unui fisier text care contine informatiile care au fost monitorizate pe un sistem linux. Graficul realizat va fi salvat local pe masina tinta sub numele "grafic.png". 

2. In scriptul "aplicatie.sh", inainte de rularea scriptului "monitor.sh" am trimis pe masina tinta codul din "plot.py" folosind comanda: "scp plot.py daria@10.0.2.15:" (exemplul este pentru sistemul linux ubuntu).

3. In scriptul "monitor.sh" am facut unele modificari precum:
    - am creat un fisier unic pe fiecare masina tinta in care am salvat datele ce vor fi introduse in grafic.
    - am oferit permisiuni de executie scriptului "plot.py" de pe masina tinta, apoi l-am rulat folosind comanda: "python3 plot.py".

4. Dupa executarea scriptului "monitor.sh", am copiat graficul de pe masina tinta pe masina gazda folosind comanda: "scp daria@10.0.2.5:grafic.png .", apoi l-am redenumit, adaugand "_{numele sistemului pe care il reprezinta}".

5. Am mai creat un fisier "/home/daria/parole_vms", i-am modificat owner-ul si group owner-ul in *root* si i-am dat drepturi de citire si scriere doar lui *root*. In acest fisier am salvat parolele necesare pentru conectarea pe fiecare sistem linux tinta.

# 25.06.2024

- am configurat aplicatia astfel incat parola sa fie introdusa automat in cazul operarii remote, folosind *sshpass*, parola fiind extrasa din fisierul descris anterior.

- am creat un fisier numit "statistici" in care am concatenat rezultatul monitorizarii pe sistemele linux.

- am creat un alt fisier, numit "pachete" in care am salvat pachetele instalate pe fiecare sistem.

- am scris functiile *verificaExistentaPachete*, *osDetalii* si *verificaDNS*. Prima e pentru fisierul nou creat "pachete", a doua extrage informatiile despre distributie si despre versiunea kernelului, iar ultima trimite un singur pachet si asteapta o secunda pentru raspuns de la serverul DNS.

# 27.06.2024

- am modificat scriptul "aplicatie.sh" astfel incat la rularea acestuia sa fie nevoie sa adaug ca parametrii *user@ip* si *nume sistem* (de ex: 'ubuntu') pentru a putea generaliza pentru orice sistem linux. Rezultatele vor fi scrise cu append in fisierele "statistici" si "pachete".