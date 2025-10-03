include ../../../../etc/Makefile.conf

DEVICE ?= numworks
PROG = keys
EADK_APP_NAME = \"OMicroB-keys\"

# FIXME: my examples of recursive functions broke quite quickly, do they perform better with an increased STACK_SIZE and HEAP_SIZE ?
STACK_SIZE = 8192  # 2^13 = 8192
HEAP_SIZE = 8192  # 2^13 = 8192

TARGETS := $(PROG).elf $(PROG).hex

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(PROG).ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

.PHONY: tests
tests:
	@echo "Testing the bytecode version:"
	./$(PROG).byte
	@echo "Testing the omicrob version:"
	./$(PROG).elf

.PHONY: clean
clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa


NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
