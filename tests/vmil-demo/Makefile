include ../../etc/Makefile.conf

SOURCES := demo.ml
TARGETS := demo.byte demo.c demo.elf demo.o demo.avr demo.hex
ATTY := /dev/tty.usbmodem*

all: demo.hex demo.elf

demo.hex: demo.ml
	$(BIN)/omicrob -circuitppx -device arduino-uno -v demo.ml -o $@

demo.elf: demo.ml
	$(BIN)/omicrob -circuitppx -device arduino-uno -v demo.ml -o $@

flash: demo.hex
	$(BIN)/omicrob -device arduino-uno -flash -v $^

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
