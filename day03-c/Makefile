.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work gcc:15.2 bash -c \
		"gcc -Wall -O3 -s -o day03 day03.c && time ./day03 < input.txt"
