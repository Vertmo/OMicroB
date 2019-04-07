include ../../../etc/Makefile.conf

mbradioacc.combined_hex: mbradioacc.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
