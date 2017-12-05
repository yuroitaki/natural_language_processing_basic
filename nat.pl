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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Tau Teng Chong */
/* Prolog Assessed Exercise */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Conjunction Predicate */

/*The base case is to verify if the single sentence follows the grammar*/

/*The recursive case splits the conjunction of sentences into single sentence*/
/*i.e. 'S1','S2' before checking its grammar*/

conj(Text):-
	sentence(Text).

conj(Text):-
	append(S1,[and|S2],Text),
	sentence(S1),
	conj(S2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Encode Predicate */

/* checks if the first word of the list is a noun recursively until the list is empty */

encode([],[]).

/* The first word 'H' is a not a noun, hence not encrypted */

encode(Text,EncodedText):-
	Text = [H|T],
	\+ noun([H]),
	EncodedText = [H|L],
	encode(T,L).

/* The first word 'H' is a noun, hence encrypted to 'EH' via char_encode/2 */

encode(Text,EncodedText):-
	Text = [H|T],
	noun([H]),
	char_encode(H,EH),
	EncodedText = [EH|L],
	encode(T,L).

/* consists of three encryption predicates and atom_chars/2 */
/* atom_chars/2 splits the word 'H' to separated alphabets 'Alp' */
/* then combines the encrypted alphabets to 'EH'*/

char_encode(H,EH):-
	first_charac(H,Initial),
	atom_chars(H,Alp),
	second_charac(Alp,Second),
	third_charac(Alp,Third),
	atom_chars(EH,[Initial,Second,Third]).

/* checks if the word 'H' is an animate */

first_charac(H,Initial):-
	animate(X),
	member(H,X)->
	Initial = a;
	Initial = d.

/* determine the length of the list of separated alphabets 'Alp' */

second_charac(Alp,Second):-
	length(Alp,Len),
	Len > 3 ->
	Second = l;
	Second = s.

/* determine the first letter 'H' of the word */

third_charac([H|_T],Third):-
	Third = H.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Actor Predicate */

/* first check if the conjunction of sentences makes sense grammatically */
/* actor_check/2 stores all the actors into the list 'A_List'*/
/* valid_actor/2 checks if all the actors are the same */

same_actor(Text):-
	conj(Text)->
	actor_check(Text,A_List),
	valid_actor(A_List).

/* determine if the first word 'A' is an actor */
/* by checking if the second word 'V' is a verb */

actor_check([_X],[]).
	
actor_check([A,V|T],A_List):-
	verb([V])->
	A_List = [A|L],
	actor_check([V|T],L);
	actor_check([V|T],A_List).

/* checks if all the actors 'H' are the same */

valid_actor([_H]).

valid_actor([H,H|T]):-
	valid_actor([H|T]).
	
	
	
	
	