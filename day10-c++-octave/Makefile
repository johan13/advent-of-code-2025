.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work gcc:15.2 bash -c \
		"g++ -std=c++20 -Wall -O3 -s -o day10 day10.cc && time ./day10 < input.txt"
	docker run --rm -v $$PWD:/work -w /work gnuoctave/octave:10.1.0 bash -c \
		"time octave day10p2.m < input.txt"
