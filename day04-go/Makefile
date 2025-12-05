.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work golang:1.25 bash -c \
		"go build -ldflags='-s -w' && time ./day04 < input.txt"
