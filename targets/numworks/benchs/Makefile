include ../../../etc/Makefile.conf

DEVICE ?= numworks
EADK_APP_NAME = \"OMicroB-benchs\"

# FIXME: my examples of recursive functions broke quite quickly, do they perform better with an increased STACK_SIZE and HEAP_SIZE ?
STACK_SIZE = 8192
HEAP_SIZE = 16000

BENCHS = jdlv aQueens oDivE oNucleic
NWAS = $(foreach var,$(BENCHS),$(var).nwa)
ELFS = $(foreach var,$(BENCHS),$(var).elf)
OMICROB_OPTS = -no-shortcut-initialization -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE)

.PHONY: all
all: $(NWAS) $(ELFS)

%.elf: %.ml
	$(BIN)/omicrob -v $(OMICROB_OPTS)  $^ -o $@

%.hex: %.ml
	$(BIN)/omicrob -v $(OMICROB_OPTS) $^ -o $@

%.nwa: %.hex
	cp $^ $@

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
