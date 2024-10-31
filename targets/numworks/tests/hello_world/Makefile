include ../../../../etc/Makefile.conf

DEVICE ?= numworks
PROG = hello
EADK_APP_NAME = \"OMicroB-tests\"

# FIXME: my examples of recursive functions broke quite quickly, do they perform better with an increased STACK_SIZE and HEAP_SIZE ?
STACK_SIZE = 8192
HEAP_SIZE = 8192

# Use the first line if you want to compile also the PC simulator. FIXME: it is not at all developped for the Numworks target.
# TARGETS := $(PROG).elf $(PROG).hex
TARGETS := $(PROG).hex

all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

# FIXME: I want to be able to change the name of the application, from its Makefile, but it doesn't work so far. See https://github.com/stevenvar/OMicroB/issues/36#issuecomment-2433451780
$(TARGETS): $(PROG).ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa


NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
