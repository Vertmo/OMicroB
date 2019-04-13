include ../../../etc/Makefile.conf

mbi2c.combined_hex: mbi2c.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@ -heap-size 400

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
