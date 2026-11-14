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
Foi utilizado os comandos presentes no arquivo gerar_base_pl.py. O qual lê o CSV de imdb_top_1000.csv com pandas e seleciona os 8 campos utilizados para responder as perguntas. 

("Título, Ano, Duração, Gênero, Classificacão, Metascore, Diretor, Votos")

# Dificuldades encontradas:
-  No dataset, os gênero de um filme estão todos juntos, por exemplo, "Drama, War". Então, tive que separar individualmente cada gênero, o que acontece em "sub_atom".
- Filmes sem avaliação ou com nota 0 de autopreenchimento, não deveriam ser consideradas para o calculo das notas dos filmes para não influenciar negativamente a análise.

# Sobre as regras e perguntas:

1. Se o gênero está mais presente no dataset, então, esse gênero deve ser o que possui maior Metascore

Para responder essa pergunta foram aplicados várias regras:
- genero_unico: Separação dos vários gêneros de um filme para que fossem tratados individualmente.
- contar_genero: contagem de cada gênero.
- media_metascore: faz o cálculo da nota média dos filmes de cada gênero.
- genero_mais_presente: faz um max no calculo de contar_genero
- genero_maior_metascore: identifica qual o gênero com o maior metascore, utiliza o media_metascore.
- hipotese_verdadeira: valida a hipoteses. Com retorno de True ou False.

2. Se um filme foi dirigido pelo mesmo diretor, então, ele deve ter o mesmo metascore

Utilizando a mesma lógia da pergunta 1, as regras para essa pergunta foram separadas em:
- diretor: identifica individualmente cada diretor
- contar_diretor: conta quantas produções tem um diretor 
- diretor_variou_nota: compara filme a filme de cada diretor para identificar se houve variação em alguma nota
- hipotese_diretor_mesmo_metascore: testa a hipoteses e retorna True ou False.

3. Se um diretor fez um gênero de filme, então, todos os seus filmes devem ter o mesmo gênero.

Reutilizando as regras das perguntas 1 e 3, adicionei apenas mais duas regras:
- diretor_variou_genero: compara filme a filme de cada diretor e verifica se houve variação de gênero
- hipotese_diretor_mesmo_genero: testa a hipoteses.


# Para Testar:
1. 
genero_mais_presente(MaisPresente, Total), genero_maior_metascore(MaiorMeta, Media), (MaisPresente == MaiorMeta -> Resultado = verdadeiro ; Resultado = falso).

Output:
MaiorMeta = 'Film-Noir',
MaisPresente = 'Drama',
Media = 93.72727272727273,
Resultado = falso,
Total = 724 

2. 
hipotese_diretor_mesmo_metascore(Resultado).

Exemplo:
diretor_variou_nota('Ron Clements', Filme1, Meta1, Filme2, Meta2).

Output:
Filme1 = 'Aladdin',
Filme2 = 'Moana',
Meta1 = 86,
Meta2 = 81

3. 
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


