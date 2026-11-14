%As minhas perguntas para o dataset seguem um padrão de hipóteses. Pegando a informação 
% do dataset e testando se a afirmação é verdadeira.

% 1. Se o gênero está mais presente no dataset, então, esse gênero deve ser o que 
% possui maior Metascore

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


% ignora os filmes com nota 0

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

% 2. Se um filme foi dirigido pelo mesmo diretor, então, ele deve ter o mesmo metascore

diretor(Diretor) :-
    findall(D, (
        filme(_, _, _, _, _, _, ListaDiretor, _),
        atomic_list_concat(Lista, ', ', ListaDiretor),
        member(D, Lista)
    ), Todos),
    sort(Todos, Unicos),
    member(Diretor, Unicos).

contar_diretor(Diretor, Total) :-
    findall(Titulo, (
        filme(Titulo, _, _, _, _, _, ListaDiretor, _),
        sub_atom(ListaDiretor, _, _, _, Diretor)
    ), Filmes),
    length(Filmes, Total).

diretor_variou_nota(Diretor, Filme1, Meta1, Filme2, Meta2) :-
    filme(Filme1, _, _, _, _, Meta1, ListaDir1, _),
    filme(Filme2, _, _, _, _, Meta2, ListaDir2, _),
    Filme1 \= Filme2,
    Meta1 > 0, Meta2 > 0,
    sub_atom(ListaDir1, _, _, _, Diretor),
    sub_atom(ListaDir2, _, _, _, Diretor),
    Meta1 \= Meta2.

hipotese_diretor_mesmo_metascore(Resultado) :-
    (   diretor_variou_nota(_, _, _, _, _)
    ->  Resultado = falso
    ;   Resultado = verdadeiro
    ).

% 3. Se um diretor fez um gênero de filme, então, todos os seus filmes devem ter o mesmo gênero.

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
