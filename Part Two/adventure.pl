:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

% start at shore
i_am_at(shore).

% cave entrance is north of shore
path(shore, n, cave_entrance).
path(cave_entrance, s, shore).
% cave entrance is south of cave
path(cave, s, cave_entrance).
path(cave_entrance, n, cave) :- holding(lit_torch).
path(cave_entrance, n, cave) :-
write('Go into that dark cave without a light?  Are you crazy?'), nl,
        !, fail.
path(cave, w, veil_one).
path(cave, n, veil_two).
path(cave, e, veil_three).
path(veil_two, s, cave).

%torch is in the cave_entrance
at(torch, shore).
%ember in cave_entrance
at(ember, cave_entrance).
% keystone is in the cave
at(keystone, cave).
at(artifact, veil_two).


% These rules describe how to pick up an object. */

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('OK.'),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.

% These rules involve an action -- lighting a torch.

light(torch):-
    \+ holding(ember),
    write('You need a flame to light the torch with.'),
    !, fail.

light(torch) :-
    holding(ember),
    write('Torch is now lit.'),nl,
    %drop(torch),
    retract(holding(torch)),nl,
    assert(holding(lit_torch)),nl,
    retract(holding(ember)),nl.

light(_) :-
    write('That object is not lightable'),
    nl.


% These rules involve an action -- placing keystone in artifact
place_stone(artifact):-
    \+ holding(keystone),
    write('You need the keystone to activate this artifact'),
    !, fail.
place_stone(artifact):-
    \+ holding(artifact),
    write('You need to possess the artifact'),
    !, fail.
place_stone(artifact):-
    holding(keystone),
    holding(artifact),
    write('You place the stone into the artifact.'),
    retract(holding(keystone)),nl,
    retract(holding(artifact)),nl,
    assert(holding(earth)),
    write('You hold a special sphere named earth. The sphere resonates in your hands.'), nl,
    write('Power surges through you. You feel empowered.'),nl,
    write('Suddenly a gang of rocks come crashing down on you. You fall to the ground unconsious. . .'), nl, finish, !. 
    

% These rules describe how to put down an object. 

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('OK.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


% Rules that define direction the player can go

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

% Inventory check for player
i :- 
  holding(_X),                     % make sure you have at least one thing
  write('You have: '),nl,
  list_possessions.
i :- 
  write('You have nothing'),nl.

% Lists possesions
list_possessions:-
  holding(X),
  tab(2),write(X),nl,
  fail.
list_possessions.

% This rule tells how to move in a given direction. 

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look.

go(_) :-
        write('You can''t go that way.').


% This rule tells how to look around you.

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */
notice_objects_at(Place) :-
        at(torch, Place),
        write('You see a used '), write(torch), write(' that perhaps could be lightable. . .'), nl,
        !.
notice_objects_at(Place) :-
        at(artifact, Place),
        write('You see an ancient '), write(artifact), write(' before you.').
notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w.     -- to go in that direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        write('drop(Object).      -- to put down an object.'), nl,
        write('light(Object).     -- to light an object.'), nl,
        write('place_stone(artifact). -- to place stone in artifact.'),nl,
        write('look.              -- to look around you again.'), nl,
        write('i.                 -- to check your inventory.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


% This rule prints out instructions and tells where you are.

start :-
        instructions,
        look.


% These rules describe the various rooms.  Depending on
% circumstances, a room may have more than one description.

describe(shore) :- write('You are on the shore. Your skin is dry and burnt from the sun.'), nl,
                write('You need shelter before you burn to a crisp. There is a cave north of where you are.'), nl.
describe(cave_entrance) :- write('You are at the cave entrance, just outside of it. Behind you is the shore.'), nl,
                write('In front of you (north) lies a dark passage into the cave.').
describe(cave) :- holding(keystone),
                write('As you grab the stone and look around in the cave, you notice three veils: one west of you, one north of you, and the other east of you.'), nl,
                write('There is no turning back! You must choose the correct veil.'), nl, nl,
                write('There''s a sign post infront of the veils: '), nl,
                write('What is the Elvish word for friend?'), nl,
                write('(West) Leftmost veil reads: Dagnir'),nl,
                write('(North) Middle veil reads: Mellon'), nl,
                write('(East) Rightmost veil reads: Gurth'), nl, !.
describe(cave) :- write('You enter the cave. The cave flickers with your lit torch. Ahead, you can see a stone shimmering in the dark.'),nl,
                write('Look around you.').
describe(veil_one) :- write('You have opened the leftmost veil only to find a hungry kitty. You perish being eaten alive by its cute angry paws.'),nl,
                    die.                

describe(veil_two) :- write('You open the middle veil and find an ancient artifact. You notice it has a crevice that is shaped similar to the stone you picked up previously.'),nl.
describe(veil_three) :- write('You open the rightmost veil only to find a group of feinding cannibals. Your body is eaten and cooked in the soup. :)'),nl,
                    die.
