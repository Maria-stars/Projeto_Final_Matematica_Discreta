# Projeto Final de Lógica e Matemática Discreta

**Estudante:** Maria Eduarda dos Santos  
**Projeto:** Knowledge Engine — uma base de conhecimento sobre filmes em Prolog

## Sobre o projeto

A inspiração para as perguntas partiu de uma iniciação científica que realizei no ensino médio sobre filmes de animação. A partir disso, quis trabalhar com uma base de filmes e testar algumas hipóteses sobre os gêneros, os diretores e as notas da crítica.

As minhas perguntas seguem um padrão de hipóteses: pego as informações do dataset e verifico se elas sustentam uma afirmação. Para isso, utilizo Python para preparar os dados e gerar a base de conhecimento. As perguntas são respondidas pelas regras em Prolog.

## Dataset utilizado:

[IMDB Movies Dataset — Kaggle, Harshit Shankhdhar](https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows).

O arquivo utilizado é o `imdb.csv` (originalmente chamado `imdb_top_1000.csv`), com **1.000 registros e 16 colunas**. Dela, foram selecionados **8 campos**, misturando variáveis qualitativas e quantitativas.

### Explicação de cada coluna do CSV

Os nomes abaixo correspondem às colunas que estão no arquivo utilizado no projeto.

| Coluna | Descrição | Utilizada na base Prolog? |
| --- | --- | --- |
| `Poster_Link` | Pôster: link para a imagem do pôster do filme. | Não |
| `Series_Title` | Título: nome do filme. | Sim |
| `Released_Year` | Ano: ano em que o filme foi lançado. | Sim |
| `Certificate` | Certificado: classificação etária registrada para o filme. | Não |
| `Runtime` | Duração: tempo de duração do filme, escrito com a indicação de minutos. | Sim |
| `Genre` | Gênero: um ou mais gêneros associados ao filme, como Drama e Comédia. | Sim |
| `IMDB_Rating` | Nota IMDb: avaliação dos usuários para o filme. | Sim |
| `Overview` | Descrição: breve resumo do enredo do filme. | Não |
| `Meta_score` | Metascore: pontuação da crítica para o filme. | Sim |
| `Director` | Diretor: nome de quem dirigiu o filme. Nesta tabela, cada registro possui um nome nesse campo. | Sim |
| `Star1` | Elenco: primeiro nome de destaque listado no registro do filme. | Não |
| `Star2` | Elenco: segundo nome de destaque listado no registro do filme. | Não |
| `Star3` | Elenco: terceiro nome de destaque listado no registro do filme. | Não |
| `Star4` | Elenco: quarto nome de destaque listado no registro do filme. | Não |
| `No_of_Votes` | Votos: quantidade de votos recebidos pelo filme no IMDb. | Sim |
| `Gross` | Bilheteria: valor de arrecadação registrado para o filme. | Não |

### Campos selecionados

A base utiliza, nesta ordem: **Título, Ano, Duração, Gênero, Nota IMDb, Metascore, Diretor e Votos**.

Título, gênero e diretor são informações qualitativas. Ano, duração, notas e votos são informações quantitativas.

## Organização dos arquivos

| Arquivo | Para que serve |
| --- | --- |
| `imdb.csv` | Tabela-fonte com os dados dos filmes. |
| `gerar_base_pl.py` | Script Python que lê o CSV e gera `filmes.pl`. |
| `filmes.pl` | Base de conhecimento com 1.000 fatos `filme/8`. |
| `perguntas.pl` | Regras auxiliares e hipóteses das três perguntas, escritas diretamente em Prolog. |
| `README.md` | Explicação da construção do projeto e de como rodá-lo. |

## Como a base foi construída

No arquivo `gerar_base_pl.py`:

- Seleção dos 8 campos;
- Retirada de `min`da duração e tratando o tempo como campo numerico;
- Representação campos numéricos ausentes ou inválidos com `0`.
- Tratamento de apóstrofos e barras nos textos para preservar os valores em Prolog.
- Escreve um fato para cada registro no arquivo `filmes.pl`

O formato de cada fato é:

```prolog
filme(Titulo, Ano, Duracao, Generos, NotaIMDb, Metascore, Diretor, Votos).
```

Exemplo real da base:

```prolog
filme('The Shawshank Redemption', 1994, 142, 'Drama', 9.3, 80, 'Frank Darabont', 2343110).
```

## Dificuldades encontradas e cuidados com os dados

- Os gêneros de um filme aparecem juntos, como `'Action, Adventure, Drama'`. Então, precisei separar cada gênero com `atomic_list_concat/3` e verificar a presença com `member/2`. Assim, `Music` e `Musical` são tratados como gêneros diferentes.
- Um filme pode participar da contagem de mais de um gênero. Por isso, a soma das contagens dos gêneros pode ultrapassar o total de filmes.
- Registros sem matescore são representados com `0` e desconsiderados nos cálculos de média e na comparação de notas, utilizando `Meta > 0`.
- Para relacionar dois filmes ao mesmo diretor, utilizo a mesma variável no campo `Director` dos dois fatos. Assim, a comparação exige o nome completo igual.
- A comparação de gêneros considera listas ordenadas, evitando que `'Drama, Crime'` e `'Crime, Drama'` sejam tratados como combinações diferentes.

## Sobre as regras e perguntas

### 1. Será que o gênero com mais produções é também o com maior Metascore médio?

A minha hipótese é: se um gênero está mais presente no dataset, então ele também deve ter a maior média de avaliação da crítica.

Para responder, as regras foram separadas em:

- `genero_do_filme/2`: separa o texto de gêneros e verifica cada gênero completo.
- `genero_unico/1`: lista os gêneros sem repetição.
- `contar_genero/2`: conta quantos filmes estão associados a cada gênero.
- `media_metascore/2`: calcula a média das notas válidas dos filmes daquele gênero.
- `genero_mais_presente/2`: identifica a maior contagem e os gêneros que atingem esse valor.
- `genero_maior_metascore/2`: identifica a maior média e os gêneros que atingem esse valor.
- `hipotese_verdadeira/2`: verifica se existe um gênero entre os vencedores dos dois grupos.
- `hipotese_genero_mais_presente/1`: retorna `verdadeiro` ou `falso` para a hipótese.

Essa pergunta utiliza **agrupamento por gênero, contagem, média e comparação de máximos**.

Consulta:

```prolog
genero_mais_presente(MaisPresente, Total),
genero_maior_metascore(MaiorMeta, Media),
hipotese_genero_mais_presente(Resultado).
```

Resultado obtido no SWI-Prolog:

```text
MaisPresente = 'Drama'
Total = 724
MaiorMeta = 'Film-Noir'
Media = 93.72727272727273
Resultado = falso
```

Assim, a hipótese não é sustentada pelos dados: Drama é o gênero mais presente, enquanto Film-Noir tem a maior média de Metascore.

### 2. Será que os filmes dirigidos pelo mesmo diretor possuem o mesmo Metascore?

A hipótese é que os filmes de um mesmo diretor tenham a mesma nota da crítica. Para verificar isso, procuro um contraexemplo: dois filmes do mesmo diretor com notas válidas diferentes.

As regras relacionadas a essa pergunta são:

- `diretor/1`: lista os diretores sem repetição.
- `contar_diretor/2`: conta os filmes de um diretor. É uma regra de apoio disponível para explorar a base.
- `diretor_variou_nota/5`: procura dois filmes distintos do mesmo diretor, com Metascores válidos e diferentes.
- `hipotese_diretor_mesmo_metascore/1`: verifica se existe algum contraexemplo na base e retorna `verdadeiro` ou `falso`.

Essa pergunta utiliza **comparação entre registros, composição de condições e busca de contraexemplo**.

Consulta:

```prolog
hipotese_diretor_mesmo_metascore(Resultado).
```

Resultado obtido:

```text
Resultado = falso
```

Para visualizar um contraexemplo:

```prolog
diretor_variou_nota('Ron Clements', Filme1, Meta1, Filme2, Meta2).
```

Uma resposta obtida é:

```text
Filme1 = 'Aladdin'
Meta1 = 86
Filme2 = 'Moana'
Meta2 = 81
```

Esses dois filmes já mostram que a hipótese geral não se sustenta na base. Como as notas ausentes são ignoradas, a comparação exige duas notas maiores que zero.

### 3. Será que todos os filmes de um diretor possuem a mesma combinação de gêneros?

A ideia inicial era entender se um diretor se mantém nos mesmos gêneros. Para deixar a pergunta mais precisa, comparo o conjunto de gêneros dos seus filmes.

Por exemplo, `'Action, Adventure, Drama'` e `'Crime, Drama, Mystery'` são combinações diferentes, mesmo compartilhando o gênero Drama.

Reutilizando a base de filmes, foram adicionadas estas regras:

- `generos_ordenados/2`: separa e ordena os gêneros de cada filme, removendo repetições.
- `diretor_variou_genero/5`: procura dois filmes do mesmo diretor com conjuntos de gêneros diferentes.
- `hipotese_diretor_mesmo_genero/1`: verifica se existe algum contraexemplo na base e retorna `verdadeiro` ou `falso`.

Essa pergunta utiliza **comparação entre registros, predicado auxiliar, tratamento de conjuntos e composição de regras**.

Consulta:

```prolog
hipotese_diretor_mesmo_genero(Resultado).
```

Resultado obtido:

```text
Resultado = falso
```

Para visualizar um contraexemplo:

```prolog
diretor_variou_genero('Akira Kurosawa', Filme1, Gen1, Filme2, Gen2).
```

Uma resposta obtida é:

```text
Filme1 = 'Shichinin no samurai'
Gen1 = 'Action, Adventure, Drama'
Filme2 = 'Tengoku to jigoku'
Gen2 = 'Crime, Drama, Mystery'
```

Assim, a combinação de gêneros não é sempre igual nos filmes de um mesmo diretor. Isso não significa que os filmes não compartilhem nenhum gênero.

## Como rodar o projeto

### 1. Preparar o ambiente

É necessário ter **Python 3** e **SWI-Prolog** instalados. O Python utiliza apenas a biblioteca padrão.

Baixe ou clone o repositório e abra um terminal na pasta que contém o CSV e os arquivos do projeto. Para conferir as instalações:

```bash
python --version
swipl --version
```

Se o seu sistema utiliza `python3`, substitua `python` por `python3` nos comandos.

### 2. Gerar a base Prolog

Execute:

```bash
python gerar_base_pl.py
```

A saída esperada é:

```text
Arquivo filmes.pl atualizado com 8 colunas!
```

Execute o comando dentro da pasta do projeto. Ele substitui somente `filmes.pl`. O arquivo `imdb.csv` precisa estar nessa mesma pasta.

### 3. Carregar a base e as regras

No terminal, execute:

```bash
swipl
```

No console do Prolog, carregue:

```prolog
['perguntas.pl'].
```

O arquivo de regras carrega `filmes.pl` automaticamente. 

### 4. Executar as três perguntas

No console do Prolog, execute cada consulta separadamente:

```prolog
hipotese_genero_mais_presente(Resultado).
```

```prolog
hipotese_diretor_mesmo_metascore(Resultado).
```

```prolog
hipotese_diretor_mesmo_genero(Resultado).
```

Na base enviada, as três retornam `Resultado = falso`. As consultas detalhadas das seções anteriores permitem visualizar os gêneros, as médias e os contraexemplos.

Cada consulta termina com ponto final. O símbolo `?-` é o prompt do console e não precisa ser digitado. Quando houver mais respostas, utilize `;` para pedir a próxima. Os pares de filmes aparecem em uma única ordem para evitar repetições.

Para encerrar:

```prolog
halt.
```
