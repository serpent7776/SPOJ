% vim: set ft=prolog:
:- use_module(library(clpfd)).

:- initialization main.

read_int(N) :-
	read_line_to_codes(user_input, X),
	atom_codes(A, X),
	atom_number(A, N).

gen_string(K, L) :-
	length(L, K),
	Max is K + 96,
	L ins 97..Max,
	all_different(L),
	label(L).

print_strings(L) :-
	atom_codes(Str, L),
	format('~s~n', Str),
	fail.

run_test() :-
	read_int(K),
	!,
	gen_string(K, L),
	print_strings(L).

main() :-
	read_int(T),
	!,
	between(1, T, _),
	run_test().
