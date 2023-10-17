IN1=in-1
BENCH_OUT=bench.txt

all: cpp c rust ocaml sml luajit swipl check bench

.PHONY: cpp
cpp: cpp-clang cpp-gcc cpp-ref

cpp-clang: TPERM2.cpp
	clang++ -Wall -Wextra -pedantic -O2 -o cpp-clang -std=c++17 -g TPERM2.cpp

cpp-gcc: TPERM2.cpp
	g++ -Wall -Wextra -pedantic -O2 -o cpp-gcc -std=c++17 -g TPERM2.cpp

cpp-ref: TPERM2-ref.cpp
	clang++ -Wall -Wextra -pedantic -O2 -o cpp-ref -std=c++17 -g TPERM2-ref.cpp

c: c-gcc c-clang

c-gcc: TPERM2.c
	gcc -Wall -Wextra -pedantic -O2 -o c-gcc -std=c17 -g TPERM2.c

c-clang: TPERM2.c
	clang -Wall -Wextra -pedantic -O2 -o c-clang -std=c17 -g TPERM2.c

rust: TPERM2.rs
	rustc -g -o ./rust -O TPERM2.rs

ocaml: TPERM2.ml
	ocamlopt -o ./ocaml TPERM2.ml

sml: sml-mlton

sml-mlton: TPERM2.sml
	mlton -output sml-mlton TPERM2.sml

luajit: TPERM2.lua
	luajit -b TPERM2.lua luajit

swipl: tperm.pl
	swipl -q -O -t main -o ./swipl -c tperm.pl

.PHONY: check
check:
	./cpp-clang < ${IN1} > out/cpp-clang
	diff -u out/cpp-clang out/ref-1 | head
	./cpp-gcc < ${IN1} > out/cpp-gcc
	diff -u out/cpp-gcc out/ref-1 | head
	# ref implements different algorithm
	./cpp-ref < ${IN1} > out/cpp-ref
	diff -u out/cpp-ref out/ref-2 | head
	./c-gcc < ${IN1} > out/c-gcc
	diff -u out/c-gcc out/ref-1 | head
	./c-clang < ${IN1} > out/c-clang
	diff -u out/c-clang out/ref-1 | head
	./rust < ${IN1} > out/rust
	diff -u out/rust out/ref-1 | head
	./ocaml < ${IN1} > out/ocaml
	diff -u out/ocaml out/ref-1 | head
	./sml-mlton < ${IN1} > out/sml-mlton
	diff -u out/sml-mlton out/ref-1 | head
	luajit ./luajit < ${IN1} > out/luajit
	diff -u out/luajit out/ref-1 | head
	# swipl implements different algorithm
	./swipl < ${IN1} > out/swipl
	diff -u out/swipl out/ref-2 | head

.PHONY: bench
bench:
	@: > ${BENCH_OUT}
	@echo "cpp-clang" >> ${BENCH_OUT}
	./bench ./cpp-clang >> ${BENCH_OUT}
	@echo "cpp-gcc" >> ${BENCH_OUT}
	./bench ./cpp-gcc >> ${BENCH_OUT}
	@echo "cpp-ref" >> ${BENCH_OUT}
	./bench ./cpp-ref >> ${BENCH_OUT}
	@echo "c-gcc" >> ${BENCH_OUT}
	./bench ./c-gcc >> ${BENCH_OUT}
	@echo "c-clang" >> ${BENCH_OUT}
	./bench ./c-clang >> ${BENCH_OUT}
	@echo "rust" >> ${BENCH_OUT}
	./bench ./rust >> ${BENCH_OUT}
	@echo "ocaml" >> ${BENCH_OUT}
	./bench ./ocaml >> ${BENCH_OUT}
	@echo "sml-mlton" >> ${BENCH_OUT}
	./bench ./sml-mlton >> ${BENCH_OUT}
	@echo "luajit" >> ${BENCH_OUT}
	./bench luajit ./luajit >> ${BENCH_OUT}
	@echo "swipl" >> ${BENCH_OUT}
	./bench ./swipl >> ${BENCH_OUT}
	@awk -f stat.awk < $(BENCH_OUT)

stat:
	@awk -f stat.awk < $(BENCH_OUT)
