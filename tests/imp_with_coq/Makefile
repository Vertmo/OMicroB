include ../../etc/Makefile.conf

impdriver.bin: imp.mli imp.ml impdriver.ml
	$(BIN)/omicrob -v -device wemos-d1-mini $^ -stack-size=1000 -heap-size=2000

flash: impdriver.bin
	$(BIN)/omicrob -v -device wemos-d1-mini -flash $^

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
