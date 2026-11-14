import csv
with open('imdb_top_1000.csv', encoding='utf-8') as f, open('filmes.pl', 'w', encoding='utf-8') as out:
    r = csv.DictReader(f)
    for row in r:
        t = row['Series_Title'].replace(\"'\", \"\\\\'\")
        y = row['Released_Year'] if row['Released_Year'].isdigit() else '0'
        dur = row['Runtime'].replace(' min', '').strip()
        dur = dur if dur.isdigit() else '0'
        g = row['Genre'].replace(\"'\", \"\\\\'\")
        rt = row['IMDB_Rating'] if row['IMDB_Rating'] else '0.0'
        meta = row['Meta_score'].strip() if row['Meta_score'].strip().isdigit() else '0'
        d = row['Director'].replace(\"'\", \"\\\\'\")
        v = row['No_of_Votes'].strip() if row['No_of_Votes'].strip().isdigit() else '0'
        out.write(f\"filme('{t}', {y}, {dur}, '{g}', {rt}, {meta}, '{d}', {v}).\n\")

print('Arquivo filmes.pl atualizado com 8 colunas!')
print("Título, Ano, Duração, Gênero, Classificacão, Metascore, Diretor, Votos")