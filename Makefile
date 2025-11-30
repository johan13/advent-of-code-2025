.PHONY: all $(wildcard day*/)

all: $(wildcard day*/)

$(wildcard day*/):
	@$(MAKE) -C $@
