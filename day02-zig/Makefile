.PHONY: all

all:
	docker build -t zig .
	docker run --rm -v $$PWD:/work -w /work zig sh -c \
		"zig build-exe -O ReleaseFast -fstrip day02.zig && time ./day02 < input.txt"
