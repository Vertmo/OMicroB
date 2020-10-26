include ../../../../etc/Makefile.conf

SOURCES := spim.ml spis.ml
TARGETS := spim.hex \
					 spis.hex

all: $(TARGETS)

%.hex: %.ml
	$(BIN)/omicrob -circuitppx -v $^ -device arduino-uno -mlopt -verbose -stack-size 200 -heap-size 200

flash: spim.hex
	$(BIN)/omicrob -device arduino-uno -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi *.c *.avr *.byte *.elf
	@rm -f $(TARGETS)

.PHONY: all flash clean
