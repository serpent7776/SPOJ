% vim: set ft=prolog:

read_int(Num) :-
	read_line_to_codes(user_input, Codes),
	atom_codes(A, Codes),
	atom_number(A, Num).

iota(X, ChrCode, NextChrCode) :-
	char_code(X, ChrCode),
	NextChrCode is ChrCode + 1.

run_test(0).
run_test(N) :-
	read_int(K),
	length(L, K),
	char_code('a', FirstChrCode),
	foldl(iota, L, FirstChrCode, _),
	forall(permutation(L, P), format('~s~n', [P])),
	NN is N - 1,
	run_test(NN).

main() :-
	read_int(T),
	run_test(T).
