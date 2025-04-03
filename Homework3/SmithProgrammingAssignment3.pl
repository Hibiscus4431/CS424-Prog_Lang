/* Paige Smith
  * Programming Assignment 3
  * Course: CS 424-01
  * Due: 4/9/25
  * File: SmithProgrammingAssignment3.pl
  * Description:
  * Write Prolog statement logic to answer various exercises given
  * in assignment.
  * Testing: swi-prolog sandbox with given test cases in assignment
*/

% Prolog logic that determines if two lists are disjoint
% Base case for an empty list (empty = always disjoint from any list)
disjoint([], _).

/* Take the first list and the second list and determine if the first
 *  member of the first list in in the second list at all, fails disjoint
 * if so. Use ! to prevent backtracking after HEAD has been found in LIST2
*/
disjoint([HEAD|_], LIST2) :- member(HEAD, LIST2), !, fail.  

/* Recursive call to check the tail end of list 1 and compare its
 * first element to list2
*/
disjoint([_|TAIL], LIST2) :- disjoint(TAIL, LIST2).

%============================================================================
% Prolog logic that counts the number of times an element appears in a list
% Base case for an empty list
countValues(_,[], 0). 

% Compare if value is equal to head of list, increment count if so
countValues(VALUE,[HEAD|TAIL], N) :- VALUE == HEAD, countValues(VALUE, TAIL, N1),  N is N1 +1.

% If value does not equal head then continue through the list without incrementing
countValues(VALUE, [HEAD|TAIL], N) :-  VALUE \= HEAD, countValues(VALUE, TAIL, N).

%============================================================================
% Determine the logic error of the following code:
	/*
	 * male(doug).
	 * male(paul).
	 * female(beth).
	 * parent(paul, doug).
	 * parent(paul, beth).
	 * sibling(X,Y) :- parent(Z, X), parent(Z, Y).
	*/
	
/* Answer:
 * The logic in this allows queries like sibling(beth, beth). and 
 * sibling(doug, doug). to return as true even though this logic is
 * incorrect. The sibling(X, Y) function should be corrected to fix this
 * by having logic that says X /= Y.
*/