include ../../../etc/Makefile.conf

microbit: i2cscreen.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o i2cscreen.combined_hex -heap-size 400

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean uno flash-uno
