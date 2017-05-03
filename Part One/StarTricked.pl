ufo(balloon).
ufo(clothesline).
ufo(frisbee).
ufo(waterTower).

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

precede(tuesday, wednesday).
precede(tuesday, thursday).
precede(tuesday, friday).
precede(wednesday, thursday).
precede(wednesday, friday).
precede(thursday, friday).

solve :-
	ufo(BarradaSighting), ufo(GortSighting), ufo(KlatuSighting), ufo(NiktoSighting),
	all_different([ BarradaSighting, GortSighting, KlatuSighting, NiktoSighting]),

	day(BarradaDay), day(GortDay), day(KlatuDay), day(NiktoDay),
	all_different([ BarradaDay, GortDay, KlatuDay, NiktoDay]),

	Triples = [ [msBarrada, BarradaSighting, BarradaDay], [msGort, GortSighting, GortDay], [mrKlatu, KlatuSighting, KlatuDay], [mrNikto, NiktoSighting, 
	NiktoDay] ],

	%mrKlatu made his sighting at some point earlier in the week than the one who saw the balloon, but at some point late in the week than the one who spotted the 
	%frisbee (who is not msGort).
	\+ member([msGort, frisbee, _], Triples),
	member([ _, frisbee, FrisbeeDay], Triples),
	precede(FrisbeeDay, KlatuDay),
	member([_, balloon, BalloonDay], Triples),
	precede(KlatuDay, BalloonDay),
	%Firday's sighting was made by either msBarrada or the one hwo saw a clothesline( or both).
	(member([msBarrada, clothesline, friday], Triples);
	member([_, clothesline, friday], Triples);
	member([msBarrada, _, friday], Triples) ),
	%mrNikto didnt make his sighting on tuesday.
	\+ member([mrNikto, _, tuesday], Triples),
	%mrKlatu isnt the one who's ufo was water tower.
	\+ member([mrKlatu, waterTower, _], Triples),

	tell(msBarrada, BarradaSighting, BarradaDay),
	tell(msGort, GortSighting, GortDay),
	tell(mrKlatu, KlatuSighting, KlatuDay),
	tell(mrNikto, NiktoSighting, NiktoDay).

all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write(X), write(' saw the '), write(Y), write(' on '), write(Z), write('.'), nl.