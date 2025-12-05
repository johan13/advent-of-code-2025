.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work swift:6.2 bash -c \
		"swiftc -O -whole-module-optimization -Xlinker -s day05.swift -o day05 && time ./day05 < input.txt"
