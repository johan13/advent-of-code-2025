.PHONY: all clean $(wildcard day*/)

all: $(wildcard day*/)

$(wildcard day*/):
	$(MAKE) -C $@

clean:
	@git clean -fdX
