% As minhas perguntas para o dataset seguem um padrão de hipóteses.
% Pego as informações do dataset e testo se a afirmação é verdadeira.

% 1. Será que o gênero com mais produções é também o que possui a maior media de Metascore?

genero_do_filme(Texto, Genero) :-
    atomic_list_concat(Generos, ', ', Texto),
    member(Genero, Generos).

genero_unico(Genero) :-
    findall(G, (
        filme(_, _, _, Texto, _, _, _, _),
        genero_do_filme(Texto, G)
    ), Todos),
    sort(Todos, Unicos),
    member(Genero, Unicos).

contar_genero(Genero, Total) :-
    genero_unico(Genero),
    findall(1, (
        filme(_, _, _, Texto, _, _, _, _),
        genero_do_filme(Texto, Genero)
    ), Filmes),
    length(Filmes, Total).

media_metascore(Genero, Media) :-
    genero_unico(Genero),
    findall(Meta, (
        filme(_, _, _, Texto, _, Meta, _, _),
        genero_do_filme(Texto, Genero),
        Meta > 0
    ), Notas),
    Notas \= [],
    sum_list(Notas, Soma),
    length(Notas, Qtd),
    Media is Soma / Qtd.

genero_mais_presente(Genero, MaxTotal) :-
    findall(Total-G, contar_genero(G, Total), Pares),
    Pares \= [],
    max_member(MaxTotal-_, Pares),
    member(MaxTotal-Genero, Pares).

genero_maior_metascore(Genero, MaxMedia) :-
    findall(Media-G, media_metascore(G, Media), Pares),
    Pares \= [],
    max_member(MaxMedia-_, Pares),
    member(MaxMedia-Genero, Pares).

hipotese_verdadeira(GenMaisPresente, GenMaiorMeta) :-
    genero_mais_presente(GenMaisPresente, _),
    genero_maior_metascore(GenMaiorMeta, _),
    GenMaisPresente == GenMaiorMeta.

hipotese_genero_mais_presente(Resultado) :-
    (   hipotese_verdadeira(_, _)
    ->  Resultado = verdadeiro
    ;   Resultado = falso
    ).

% 2. Será que os filmes dirigidos pelo mesmo diretor possuem o mesmo Metascore?

diretor_variou_nota(Diretor, Filme1, Meta1, Filme2, Meta2) :-
    filme(Filme1, Ano1, _, _, _, Meta1, Diretor, _),
    filme(Filme2, Ano2, _, _, _, Meta2, Diretor, _),
    Filme1-Ano1 @< Filme2-Ano2,
    Meta1 > 0,
    Meta2 > 0,
    Meta1 =\= Meta2.

% Se encontrar um contraexemplo, a hipótese é falsa.

hipotese_diretor_mesmo_metascore(Resultado) :-
    (   diretor_variou_nota(_, _, _, _, _)
    ->  Resultado = falso
    ;   Resultado = verdadeiro
    ).

% 3. Será que todos os filmes de um diretor possuem a mesma combinação de gêneros?

generos_ordenados(Texto, Generos) :-
    atomic_list_concat(Lista, ', ', Texto),
    sort(Lista, Generos).

diretor_variou_genero(Diretor, Filme1, Gen1, Filme2, Gen2) :-
    filme(Filme1, Ano1, _, Gen1, _, _, Diretor, _),
    filme(Filme2, Ano2, _, Gen2, _, _, Diretor, _),
    Filme1-Ano1 @< Filme2-Ano2,
    generos_ordenados(Gen1, Generos1),
    generos_ordenados(Gen2, Generos2),
    Generos1 \= Generos2.

hipotese_diretor_mesmo_genero(Resultado) :-
    (   diretor_variou_genero(_, _, _, _, _)
    ->  Resultado = falso
    ;   Resultado = verdadeiro
    ).
