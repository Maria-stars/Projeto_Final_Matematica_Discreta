# Projeto_Final_Matematica_Discreta

Estudante: Maria Eduarda dos Santos

Dataset utilizado: https://www.kaggle.com/datasets/amanbarthwal/imdb-movies-data

Descrição das colunas:
Pôster: link para o pôster do filme.
Título: nome do filme.
Ano: ano em que o filme foi lançado.
Certificado: classificação etária atribuída ao filme (ex.: PG, R).
Duração (min): tempo de duração do filme em minutos.
Gênero: gênero(s) do filme (ex.: Ação, Comédia, Drama).
Classificação: Avaliação dos usuários do IMDB para o filme.
Metascore: pontuação da crítica.
Diretor: diretor(es) do filme.
Elenco: atores principais do filme.
Votos: número de votos que o filme recebeu no IMDB.
Descrição: breve resumo do enredo do filme.
Número de avaliações: total de avaliações.
Título da avaliação: título da avaliação.
Crítica: crítica de cinema (crítica com o maior número de votos).

Colunas utilizadas:
Título, Ano, Duração, Gênero, Classificacão, Metascore, Diretor, Votos

Para isso, rodei no terminal o comando:
python -c "
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
"

As minhas perguntas para o dataset surgiram a partir de hipóteses:

1. Se o gênero está mais presente no dataset, então, esse gênero deve ser o que possui maior Metascore

regras (funções) adotadas:

genero_unico(Genero) :-
    findall(G, (
        filme(_, _, _, ListaGeneros, _, _, _, _),
        atomic_list_concat(Lista, ', ', ListaGeneros),
        member(G, Lista)
    ), Todos),
    sort(Todos, Unicos),
    member(Genero, Unicos).

contar_genero(Genero, Total) :-
    findall(Titulo, (
        filme(Titulo, _, _, ListaGeneros, _, _, _, _),
        sub_atom(ListaGeneros, _, _, _, Genero)
    ), Filmes),
    length(Filmes, Total).

Dificuldade encontrada: No dataset, os gênero de um filme estão todos juntos, por exemplo, "Drama, War". Então, tive que separar individualmente cada gênero, o que acontece em "sub_atom".

#ignora os filmes com nota 0

media_metascore(Genero, Media) :-
    findall(Meta, (
        filme(_, _, _, ListaGeneros, _, Meta, _, _),
        Meta > 0,
        sub_atom(ListaGeneros, _, _, _, Genero)
    ), Notas),
    Notas \= [],
    sum_list(Notas, Soma),
    length(Notas, Qtd),
    Media is Soma / Qtd.

genero_mais_presente(Genero, MaxTotal) :-
    findall(Total-G, (
        genero_unico(G),
        contar_genero(G, Total)
    ), Pares),
    max_member(MaxTotal-Genero, Pares).

genero_maior_metascore(Genero, MaxMedia) :-
    findall(Media-G, (
        genero_unico(G),
        media_metascore(G, Media)
    ), Pares),
    max_member(MaxMedia-Genero, Pares).

hipotese_verdadeira(GenMaisPresente, GenMaiorMeta) :-
    genero_mais_presente(GenMaisPresente, _),
    genero_maior_metascore(GenMaiorMeta, _),
    GenMaisPresente == GenMaiorMet

PARA RODAR:
genero_mais_presente(MaisPresente, Total), genero_maior_metascore(MaiorMeta, Media), (MaisPresente == MaiorMeta -> Resultado = verdadeiro ; Resultado = falso).

Output:
MaiorMeta = 'Film-Noir',
MaisPresente = 'Drama',
Media = 93.72727272727273,
Resultado = falso,
Total = 724 

2. Se um filme foi dirigido pelo mesmo diretor, então, ele deve ter o mesmo metascore

(aplicando a mesma lógica do gênero, levando em consideração que um filme pode ser dirigido por mais de um diretor):

% 1. Lista todos os diretores únicos da base
diretor(Diretor) :-
    findall(D, (
        filme(_, _, _, _, _, _, ListaDiretor, _),
        atomic_list_concat(Lista, ', ', ListaDiretor),
        member(D, Lista)
    ), Todos),
    sort(Todos, Unicos),
    member(Diretor, Unicos).

% 2. Conta quantos filmes cada diretor dirigiu
contar_diretor(Diretor, Total) :-
    findall(Titulo, (
        filme(Titulo, _, _, _, _, _, ListaDiretor, _),
        sub_atom(ListaDiretor, _, _, _, Diretor)
    ), Filmes),
    length(Filmes, Total).

% 3. Verifica se um diretor específico teve notas DIFERENTES (contraexemplo)
diretor_variou_nota(Diretor, Filme1, Meta1, Filme2, Meta2) :-
    filme(Filme1, _, _, _, _, Meta1, ListaDir1, _),
    filme(Filme2, _, _, _, _, Meta2, ListaDir2, _),
    Filme1 \= Filme2,
    Meta1 > 0, Meta2 > 0,
    sub_atom(ListaDir1, _, _, _, Diretor),
    sub_atom(ListaDir2, _, _, _, Diretor),
    Meta1 \= Meta2.

% 4. Testa a hipótese geral: retorna 'falso' se encontrar qualquer diretor com notas diferentes
hipotese_diretor_mesmo_metascore(Resultado) :-
    (   diretor_variou_nota(_, _, _, _, _)
    ->  Resultado = falso
    ;   Resultado = verdadeiro
    ).

PARA TESTAR:
hipotese_diretor_mesmo_metascore(Resultado).

Exemplo:
diretor_variou_nota('Ron Clements', Filme1, Meta1, Filme2, Meta2).

Output:
    Filme1 = 'Aladdin',
Filme2 = 'Moana',
Meta1 = 86,
Meta2 = 81

3. Se um diretor fez um gênero de filme, então, todos os seus filmes devem ter o mesmo gênero.

Regras:
diretor_variou_genero(Diretor, Filme1, Gen1, Filme2, Gen2) :-
    diretor(Diretor),
    filme(Filme1, _, _, Gen1, _, _, ListaDir1, _),
    filme(Filme2, _, _, Gen2, _, _, ListaDir2, _),
    Filme1 \= Filme2,
    sub_atom(ListaDir1, _, _, _, Diretor),
    sub_atom(ListaDir2, _, _, _, Diretor),
    Gen1 \= Gen2.

hipotese_diretor_mesmo_genero(Resultado) :-
    (   diretor_variou_genero(_, _, _, _, _)
    ->  Resultado = falso
    ;   Resultado = verdadeiro
    ).

PARA RODAR:
hipotese_diretor_mesmo_genero(Resultado).

Output: false

Exemplo:
Rodando: diretor_variou_genero(Diretor, Filme1, Gen1, Filme2, Gen2).
Output: 
Diretor = 'Akira Kurosawa',
Filme1 = 'Shichinin no samurai',
Filme2 = 'Tengoku to jigoku',
Gen1 = 'Action, Adventure, Drama',
Gen2 = 'Crime, Drama, Mystery'

Diretor = 'Akira Kurosawa',
Filme1 = 'Shichinin no samurai',
Filme2 = 'Ran',
Gen1 = 'Action, Adventure, Drama',
Gen2 = 'Action, Drama, War'

Diretor = 'Akira Kurosawa',
Filme1 = 'Shichinin no samurai',
Filme2 = 'Yôjinbô',
Gen1 = 'Action, Adventure, Drama',
Gen2 = 'Action, Drama, Thriller'

Ou seja, um diretor fez diversos gênero. Então, a hipóteses é falsa.

