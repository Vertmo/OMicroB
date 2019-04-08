include ../../../etc/Makefile.conf

radioblockchain.combined_hex: chain.ml communication.ml radioblockchain.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@ -heap-size 350

clean:
	rm *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
