.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work haskell:9.12 bash -c \
		"ghc -O2 -optl-s day09.hs -o day09 && time ./day09 < input.txt"
