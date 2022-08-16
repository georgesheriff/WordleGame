
main:- 
	write('Welcome to Pro-Wordle!'),nl,
	write('--------------------------------'),nl,
	build_kb,nl, 
	play.

build_kb:- 
	write('Please enter a word and its category on separate lines:'),nl,
	read(Word),
	( 
	(Word = done,nl,write('Done building the words database...'));
	read(Category) , assert(word(Word,Category)) ,
	build_kb
	).
	
play:-
	write('The available categories are: '),categories(List),write(List),nl,write('Choose a category:'),nl,
	read(C), categoryHelper(C) ,nl,
	write('Choose a length:') , nl , read(Length) , lengthHelper(Length,NewLength),
	Guesses is NewLength +1 , 
	write('Game started. You have ') , write(Guesses) , write(' guesses.'),nl,nl,
	write('Enter a word composed of '), write(NewLength) , write(' letters: ') ,nl, read(Guess1),
	random(Rand,NewLength,C),
	wordHelper(Guess1,Rand,NewLength,Guesses,C).
	
is_category(C):- 
	word(_,C).

categories(L):- 
	setof(C , is_category(C), L).

available_length(L):- 
	word(X,_), string_length( X ,L).

pick_word(W,L,C):- 
	word(W,C) , string_length(W,L). 

correct_letters(L2,[H|T],[H|T2]):-
	member(H , L2),\+member(H,T), 
	correct_letters(L2,T,T2).
	
correct_letters(L2,[H|T],CL):-
	(\+member(H , L2) ; (member(H , L2),member(H,T))),
	correct_letters(L2,T,CL).

correct_letters( _,[],[]).

correct_positions([H|T],[H|T1],[H|T2]):-
	correct_positions(T,T1,T2).

correct_positions([H|T],[H1|T1],PL):-
	H\==H1,
	correct_positions(T,T1,PL).
	
correct_positions([] ,[], []).

categoryHelper(C):- 
	\+is_category(C) , 
	write('This category does not exist.'),nl,
	write('Choose a category:'),nl, read(X), 
	categoryHelper(X).
	
categoryHelper(C):- 
	is_category(C).

lengthHelper(Length,NewLength):- 
	\+available_length(Length), 
	write('There are no words of this length.'),nl,
	write('Choose a length:'),nl, read(Length2), 
	lengthHelper(Length2,NewLength).

lengthHelper(Length,Length):- 
	available_length(Length).

wordHelper(X ,Rand,Length ,Guesses ,C):- 
	\+string_length(X, Length), 
	write('Word is not composed of 5 letters. Try again.'),nl, 
	write('Remaining Guesses are '),write(Guesses),nl,nl, 
	write('Enter a word composed of '), write(Length) , write(' letters:') , read(X2),
	wordHelper(X2,Rand,Length,Guesses,C).
	

wordHelper(X,Rand,Length ,Guesses,C):- 
	X\=Rand,
	Guesses>1 ,
	string_length(X, Length),
	string_chars(X,L1),string_chars(Rand,L2),
	correct_letters(L1,L2, R1), write('Correct letters are: '), write(R1),nl, 
	correct_positions(L1,L2,R2), write('Correct letters in correct positions are: '),write(R2),nl,
	Guesses2 is Guesses -1, 
	write('Remaining Guesses are '), write(Guesses2),nl,nl,
	write('Enter a word composed of '), write(Length) , write(' letters:'),nl,read(X2),
	wordHelper(X2,Rand,Length,Guesses2,C).
wordHelper(X,X,_,_,_):- 
	write('You Won!').
wordHelper(X1,X2,_,1,_):- 
	X1\=X2,
	write('You lost!').



random(Rand,Length,C):- 
	setof( W , pick_word(W,Length,C) , List),
	random_member(Rand , List).



	
	

