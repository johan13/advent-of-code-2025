.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work gcc:15.2 bash -c \
		"g++ -std=c++20 -Wall -O3 -s -o day10 day10.cc && time ./day10 < input.txt"
