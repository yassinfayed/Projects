build_kb():-
        write("Please enter a word and its category on seperate lines:"),nl,
		read(X),
		(
		 X=done,write("Done building the words database...");
		 read(Y),assert(word(X,Y)),build_kb()
		).
		
is_category(C):-
        word(_,C).
		
categories(L):-add([],L),!.

add(B,L):- is_category(C),
		   not(member(C,B)),
		   add([C|B],L).
add(B,L):-
           L=B,!.
		   
words(L):-helper([],L),!.

helper(B,L):-word(W,_),
             not(member(W,B)),
			 helper([W|B],L).

helper(B,L):-
            L=B,!.
available_length(N):-words(X),
                     lenhelper(X,N).

lenhelper([],N):-fail.
lenhelper([H|T],N):-atom_chars(H,L),length(L,N).
lenhelper([H|T],N):-atom_chars(H,L),length(L,M),M\==N,lenhelper(T,N).

pick_word(W,N,C):- words(X), 
				   pickhelper(W,X,N,C).
pickhelper(_,[],_,_):-!,fail.

pickhelper(H,[H|T],N,C):-atom_chars(H,L),
                         length(L,N),
						 word(H,C).
pickhelper(X,[H|T],N,C):-pickhelper(X,T,N,C).


correct(L1,[H|T],[H|T1]):-member(H,L1),
                                  correct(T,L1,T1).
correct(L1,[H|T],Z):-  \+ member(H,L1), correct(T,L1,Z).
correct(L1,[],[]).

remove_dup([],[]).
remove_dup([H|T],Res):-member(H,T),remove_dup(T,Res).
remove_dup([H|T],[H|Res]):-not(member(H,T)),remove_dup(T,Res).

correct_letters(L1,L2,Res):-remove_dup(L1,R1),remove_dup(L2,R2),correct(R1,R2,Res).


correct_positions([],[],[]).
correct_positions([H|T],[H|T1],[H|T2]):-correct_positions(T,T1,T2).
correct_positions([H|T],[H1|T1],Res):-H\==H1,
                                     correct_positions(T,T1,Res).
									 
choosecat(Y):-write("Choose a category:"),nl,
             read(X), 
			 (
			   is_category(Y),Y=X;\+is_category(X),write("This category does not exist."),nl,choosecat(Y)
			  ).

chooselength(Y,C):-write("Choose a length:"),nl,
             read(X),
			 (
			   lencat(Y,C),Y=X;\+lencat(X,C),write("There are no words of this length."),nl,chooselength(Y,C)
			  ).
			  
wordcat(L,C):-helper([],L,C),!.

helper(B,L,C):-word(W,C),
             not(member(W,B)),
			 helper([W|B],L,C).

helper(B,L,_):-
            L=B,!.
lencat(N,C):-wordcat(L,C),lencathelper(N,C,L).
lencathelper(_,_,[]):-fail.
lencathelper(N,C,[H|T]):-atom_chars(H,R),length(R,N),word(H,C).
lencathelper(N,C,[H|T]):-atom_chars(H,R),((length(R,M),M\==N);(not(word(H,C)))),lencathelper(N,C,T).

guessing(L,W,N):-nl,write("Enter a word composed of "),write(L),write(" letters"),nl,
             read(X),
			         (
					  (atom_chars(X,Z),length(Z,C),C\==L,write("Word is not composed of "),write(L),
					  write(" letters. Try again"),nl,write("Remaining guesses are "),write(N),
					  guessing(L,W,N));
					  (X\==W,N\==1,atom_chars(X,Z),length(Z,C),C==L,write("Correct letters are: "),atom_chars(W,L1),atom_chars(X,L2),
					  correct_letters(L1,L2,L3),write(L3),nl,write("Correct letters in correct positions are : "),
					  correct_positions(L1,L2,L4),write(L4),nl,write("Remaining guesses are "),Num is N-1,write(Num),
					  guessing(L,W,Num));(N==1,X\==W,write("You lost!"));
					  (X==W,write("You Won!"))
					  ).
					  
play():- categories(L),write("The available categories are: "),write(L),nl,
         choosecat(X),nl,chooselength(Y,X),nl,pick_word(W,Y,X),write("Game started. You have "),Z is Y+1,write(Z),write(" guesses"),
		 guessing(Y,W,Z).
         
main():-write("Welcome to Pro-Wordle"),nl,build_kb(),nl,play().				 

						 


						
						  

