.PHONY: all

all:
	docker build -t kotlin .
	docker run --rm -v $$PWD:/work -w /work kotlin bash -c \
		"kotlinc day08.kt -include-runtime -d day08.jar && time java -jar day08.jar < input.txt"
