%my_agent.pl

%   this procedure requires the external definition of two procedures:
%
%     init_agent: called after new world is initialized.  should perform
%                 any needed agent initialization.
%
%     run_agent(percept,action): given the current percept, this procedure
%                 should return an appropriate action, which is then
%                 executed.
%
% This is what should be fleshed out

% init_agent:-
%   format('\n=====================================================\n'),
%   format('This is init_agent:\n\tIt gets called once, use it for your initialization\n\n'),
%   format('=====================================================\n\n').

% %run_agent(Percept,Action):-
% run_agent(_, goforward ):-
%   format('\n=====================================================\n'),
%   format('This is run_agent(.,.):\n\t It gets called each time step.\n\tThis default one simply moves forward\n'),
%   format('You might find "display_world" useful, for your debugging.\n'),
%   display_world,   
%   format('=====================================================\n\n').

% load the utils.pl
% use the random
:- include('utils.pl').

% parameter for how many times of random turn to try
turn_times_max(10).

% parameter for how many times of returning to origin
% if returning to origin morn than this parameter
% climb out
origin_max(10).

% if true , enter debug mode
% show the world
debug:- false.
%debug.
	 
safe(X,Y):-
	( 
	safe_fact(X,Y);
		(no_pit(X,Y), no_wumpus(X,Y) )
	  )
.
is_wumpus(X, Y):- Xplus is X + 1, Yplus is Y + 1, Xminus is X - 1, Yminus is Y - 1,
	(  (my_stench( Xplus, Y), my_stench(X, Yplus), my_stench(Xminus, Y), my_stench(X, Yminus));
	   (my_stench( Xplus, Y), my_stench(X, Yplus), safe(Xplus, Yplus));
	   (my_stench( Xminus, Y), my_stench(X, Yminus), safe(Xminus, Yminus));
	   (my_stench(Xminus, Y), my_stench(Xplus, Y));
	   (my_stench(X, Yplus), my_stench(X, Yminus)  )   )
.
init_agent:-
	retractall(safe_fact(_,_)),
	retractall(no_pit(_,_)),
	retractall(no_wumpus(_,_)),
	retractall(current_location(_, _)),
	retractall(my_angle(_)),
	retractall(visited(_,_)),
	retractall(random_turn_times(_)),
	retractall(gold(_)),
	retractall(original_loc_times(_)),
	retractall(arrow(_)),
	retractall(wumpus_number(_)),
	assert(current_location(1,1)),
	assert(my_angle(0)),
	assert(visited(1,1)) ,
	assert(random_turn_times(0)),
	assert(original_loc_times(0)),
	assert(arrow(1)),
	assert(wumpus_number(1)),
	assert(gold(0) ) 
.

random_turn(Action):- random2(1000, Value), random_turn_times(Times), NewTimes is Times + 1 ,
	retract(random_turn_times(Times)), assert(random_turn_times(NewTimes)),
	( (Action = turnleft, Value > 500, turn_left);
	  (Action = turnright, Value =< 500, turn_right) )
.
turn_left:-
	my_angle(Angle),
	retract(my_angle(Angle) ), 
	NewAngle is ( ( Angle + 90) mod 360), 
	assert(my_angle( NewAngle ) ) 
.
turn_right:-
	my_angle(Angle),
	retract(my_angle(Angle) ), 
	NewAngle is ( ( Angle - 90) mod 360), 
	assert(my_angle( NewAngle ) ) 
.
next_location(X1, Y1):-
	current_location(X, Y), my_angle(Angle) ,
	( ( Angle = 0,   X1 is X + 1, Y1 is Y );
	  ( Angle = 90,  X1 is X, Y1 is Y + 1);
	  ( Angle = 180, X1 is X - 1, Y1 is Y);
	  ( Angle = 270, X1 is X, Y1 is Y - 1) )
.

forward_location:- 
	current_location(X,Y),retractall(current_location(X,Y)), retractall(previous_location(_,_)), assert(previous_location(X, Y)), my_angle(Angle), (
	( Angle = 0, X1 is X + 1, assert( current_location( X1, Y) ) ) ;
	( Angle = 90, Y1 is Y + 1, assert( current_location(X, Y1) ) ) ;
	( Angle = 180, X1 is X - 1, assert( current_location(X1, Y) ) );
	( Angle = 270, Y1 is Y - 1, assert( current_location(X, Y1) ) )  )
.
run_agent([_,no|_], _):-
	current_location(X,Y), assert( safe_fact(X, Y) ), assert( no_pit(X, Y)),
	Xplus is X + 1, Yplus is Y + 1, Xminus is X - 1, Yminus is Y - 1,
	assert(no_pit(Xplus, Y) ), assert( no_pit(X, Yplus) ), assert( no_pit(Xminus, Y)) , assert( no_pit(X, Yminus) ),
	fail
.
run_agent([Stench|_], _):-current_location(X,Y),  
	Xplus is X + 1, Yplus is Y + 1, Xminus is X - 1, Yminus is Y - 1,
	(Stench = no;( Stench = yes, wumpus_number(N), N = 0)),
	assert(no_wumpus(Xplus, Y) ), assert( no_wumpus(X, Yplus) ), 
	assert( no_wumpus(Xminus, Y)) , assert( no_wumpus(X, Yminus) ),
	assert( safe_fact(X, Y) ), assert( no_wumpus(X,Y)),
	fail
.
run_agent(_,_):- current_location(X, Y), X = 1, Y = 1,
	original_loc_times(Original_loc_T), 
	NewT is Original_loc_T + 1, 
	retract(original_loc_times(Original_loc_T)),
	assert(original_loc_times(NewT) ),
	fail
.
run_agent([_,_,_,_,yes], _):-
	wumpus_number(N), NewN is N - 1,
	retract(wumpus_number(N)),
	assert(wumpus_number(NewN)),
	fail
.
run_agent([_,_,_,yes,_], _):-
	retractall(current_location(_, _) ), previous_location(X, Y), assert(current_location(X, Y) ), 
	fail
.
run_agent(_,climb ):- current_location(X, Y), my_angle(Angle),X = 1, Y = 1,
	(	(gold(N),  N > 0 );
		%(random_turn_times(T),turn_times_max(TurnMax),T>TurnMax);
		(original_loc_times(Original_loc_T), origin_max(OriginalMax), Original_loc_T > OriginalMax )),
	( ( debug, display_world,  write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent([_,_,yes,_,_], grab ):- current_location(X, Y),my_angle(Angle),
	assert(safe_fact(X, Y) ), gold(N), NewNumberOfGold is N + 1, assert(gold(NewNumberOfGold)),
	( ( debug, display_world,  write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
	
run_agent([yes|_], shoot):-current_location(X, Y), my_angle(Angle), 
	X = 1, Y = 1, arrow(N) , N>0, (Angle = 0; Angle = 90) , NewN is N - 1, retractall(arrow(N)), assert(arrow(NewN)),
	( ( debug, display_world, write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.

run_agent([_,_,_,yes,_], Action):- my_angle(Angle),current_location(X, Y), (
	( Action = turnleft,
	( (Angle = 0, Y = 1 );
	  (Angle = 270, X = 1 ) ), turn_left )  ;
	( Action = turnright ,
	( ( Angle = 90, X = 1 ) ;
	  ( Angle = 180, Y = 1 )  ), turn_right )  ;
	  random_turn(Action) ), 
	( ( debug, display_world,  write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent([no,no,no,no,no], goforward):-  my_angle(Angle),current_location(X, Y), 
	forward_location, assert(safe_fact(X, Y) ), 
	Xplus is X + 1, Yplus is Y + 1, Xminus is X - 1, Yminus is Y - 1,
	assert( safe_fact(Xplus, Y) ), assert( safe_fact(X, Yplus) ), assert( safe_fact(Xminus, Y)) , assert( safe_fact(X, Yminus) ),
	( ( debug, display_world,  write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent(_,goforward):-current_location(X,Y),my_angle(Angle),
	next_location(X1, Y1),safe(X1, Y1), forward_location,
	( ( debug, display_world, write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent([_,yes|_], Action):- current_location(X,Y) ,my_angle(Angle),
	random_turn(Action),
	( ( debug, display_world, write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent([yes|_], shoot):-current_location(X,Y), my_angle(Angle),arrow(N), N > 0, original_loc_times(OriginT), OriginT >1 ,
	next_location(X1, Y1), (\+ no_wumpus(X1, Y1)), retract(arrow(N)), NewN is N -1 , assert(arrow(NewN)),
	( ( debug, display_world, write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.
run_agent([yes|_], Action):- current_location(X,Y), my_angle(Angle),
	random_turn(Action),
	( ( debug, display_world, write(current_location(X,Y)), write(my_angle(Angle)) ) ; true)
.

