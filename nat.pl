%%%%% Natural Language Program

sentence(S) :-
	noun_phrase(NP),
	verb_phrase(VP),
	append(NP, VP, S).

noun_phrase(NP) :-
	article(A),
	noun(N),
	append(A, N, NP).

verb_phrase(V) :-
	verb(V).
verb_phrase(VP) :-
	verb(V),
	noun_phrase(NP),
	append(V, NP, VP).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* The required predicates and argument positions are:

	a.  conj(Text)
	b.  encode(Text, EncodedText)
	c.  same_actor(Text)

*/

/* conj predicate */

conj(Text):-
	\+ member(and,Text)->
	sentence(Text);
	conj_check(Text).

conj_check(Text):-
	\+ append(_S1,[and|_S2],Text)->
	sentence(Text).
	   
conj_check(Text):-
	append(S1,[and|S2],Text),
	sentence(S1),
	conj_check(S2).


/* encode predicate*/

encode([],[]).

encode(Text,EncodedText):-
	Text = [H|T],
	\+ noun([H]),
	EncodedText = [H|L],
	encode(T,L).

encode(Text,EncodedText):-
	Text = [H|T],
	noun([H]),
	char_encode(H,EH),
	EncodedText = [EH|L],
	encode(T,L).

char_encode(H,EH):-
	animate_check(H,Initial),
	atom_chars(H,L_Word),
	length_check(L_Word,Second),
	third_charac(L_Word,Third),
	atom_chars(EH,[Initial,Second,Third]).

animate_check(H,Initial):-
	animate(X),
	member(H,X)->
	Initial = a;
	Initial = d.

length_check(L_Word,Second):-
	length(L_Word,Len),
	Len > 3 ->
	Second = l;
	Second = s.

third_charac([H|_T],Third):-
	Third = H.



/* same actor predicate */

same_actor(Text):-
	conj(Text)->
	actor_check(Text,A_List),
	valid_actor(A_List).

actor_check([_X],[]).
	
actor_check([A,V|T],A_List):-
	verb([V])->
	A_List = [A|L],
	actor_check([V|T],L);
	actor_check([V|T],A_List).

valid_actor([_H]).

valid_actor([H,H|T]):-
	valid_actor([H|T]).
	
	
	
	
	