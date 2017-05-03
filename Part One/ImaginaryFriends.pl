imaginaryFriend(grizzlyBear).
imaginaryFriend(moose).
imaginaryFriend(seal).
imaginaryFriend(zebra).

adventure(circus).
adventure(rockBand).
adventure(spaceship).
adventure(train).

solve :-
	imaginaryFriend(JoanneFriend),  imaginaryFriend(LouFriend), imaginaryFriend(RalphFriend), imaginaryFriend(WinnieFriend),
	all_different([JoanneFriend, LouFriend, RalphFriend, WinnieFriend]),
	adventure(JoanneAdventure), adventure(LouAdventure), adventure(RalphAdventure), adventure(WinnieAdventure),
	all_different([JoanneAdventure, LouAdventure, RalphAdventure, WinnieAdventure]),

	Triples = [[ joanne, JoanneFriend, JoanneAdventure], [ lou, LouFriend, LouAdventure], [ ralph, RalphFriend, RalphAdventure], [ winnie, WinnieFriend,
	 WinnieAdventure] ],

	 %The seal who isn't the creation of either Joanne or Lou neither rode to the moon in spaceship nor went on train
	 (member([ joanne, seal, _ ], Triples) ; member([ lou, seal, _ ], Triples)),
	 \+ member([ _, seal, spaceship], Triples),
	 \+ member([ _, seal, train], Triples),
	 % Joanne's imaginary friend (not gizzly) went to the circus
	 \+ member([ joanne, grizzlyBear, _], Triples),
	  member([ joanne, _, circus], Triples),
	 \+ member([ _, grizzlyBear, circus], Triples),
	
	 % Winnie has zebra as imaginary friend
	 member([winnie, zebra, _], Triples),
	 % grizzlyBear didnt ride the spaceship
	 \+ member([_, grizzlyBear, spaceship], Triples),

	 tell(joanne, JoanneFriend, JoanneAdventure),
	 tell(lou, LouFriend, LouAdventure),
	 tell(ralph, RalphFriend, RalphAdventure),
	 tell(winnie, WinnieFriend, WinnieAdventure).

all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write('Young '), write(X), write(' had the '), write(Y),
    write(' as an imaginary friend, and their adventure was '), write(Z), write('.'), nl.


