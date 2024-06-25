import matplotlib.pyplot as plt

def citeste_date_fisier(nume_fisier):
    descrieri = []
    valori = []
    with open(nume_fisier, 'r') as file:
        for line in file:
            if line.strip() and not line.startswith('nume, val'):  # nu iau in considerare antetul
                descriere, valoare = line.strip().split(', ')
                if 'Gi' in valoare:
                    valoare = float(valoare.replace('Gi', '').replace(',', '.'))  # elimin 'Gi' si inlocuiesc ',' cu '.' daca e necesar
                elif 'Mi' in valoare:
                    valoare = float(valoare.replace('Mi', '').replace(',', '.'))  # elimin 'Mi' si inlocuiesc ',' cu '.' daca e necesar
                elif 'Ti' in valoare:
                    valoare = float(valoare.replace('Ti', '').replace(',', '.'))  # elimin 'Ti' si inlocuiesc ',' cu '.' daca e necesar
                else:
                    valoare = float(valoare)  
                descrieri.append(descriere)
                valori.append(valoare)
    return descrieri, valori

def afiseaza_grafic(descrieri, valori):
    plt.figure(figsize=(10, 9))
    plt.barh(descrieri, valori, color='salmon')
    plt.xlabel('Valoare')
    plt.ylabel('Tipul')
    plt.title('Grafic date sistem linux')
    plt.gca().invert_yaxis() 
    for i, v in enumerate(valori):
        plt.text(v + 0.1, i, str(v), ha='left', va='center')  
    plt.tight_layout()
    plt.show()

nume_fisier = 'plot'
descrieri, valori = citeste_date_fisier(nume_fisier)

afiseaza_grafic(descrieri, valori)
plt.savefig('grafic')