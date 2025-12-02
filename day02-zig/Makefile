.PHONY: all

all:
	docker build -t zig .
	docker run --rm -i -v $$PWD:/work -w /work zig zig run day02.zig < input.txt
