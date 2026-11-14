# Projeto_Final_Matematica_Discreta

Estudante: Maria Eduarda dos Santos

Dataset utilizado: https://www.kaggle.com/datasets/amanbarthwal/imdb-movies-data

Tamanho do dataset: 10.000 registros 

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

A inspiração para as perguntas partiram de uma iniciação científica que realizei no ensino médio sobre filmes de animação.

# Para criar o banco em prolog:
Foi utilizado os comandos presentes no arquivo gerar_base_pl.py

1. 

Dificuldade encontrada: No dataset, os gênero de um filme estão todos juntos, por exemplo, "Drama, War". Então, tive que separar individualmente cada gênero, o que acontece em "sub_atom".


PARA RODAR:
genero_mais_presente(MaisPresente, Total), genero_maior_metascore(MaiorMeta, Media), (MaisPresente == MaiorMeta -> Resultado = verdadeiro ; Resultado = falso).

Output:
MaiorMeta = 'Film-Noir',
MaisPresente = 'Drama',
Media = 93.72727272727273,
Resultado = falso,
Total = 724 

2. 

PARA TESTAR:
hipotese_diretor_mesmo_metascore(Resultado).

Exemplo:
diretor_variou_nota('Ron Clements', Filme1, Meta1, Filme2, Meta2).

Output:
    Filme1 = 'Aladdin',
Filme2 = 'Moana',
Meta1 = 86,
Meta2 = 81

3. 
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

