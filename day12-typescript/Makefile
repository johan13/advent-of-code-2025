.PHONY: all

all:
	docker run --rm -v $$PWD:/work -w /work node:24.12 bash -c \
		"time node day12.mts < input.txt"
