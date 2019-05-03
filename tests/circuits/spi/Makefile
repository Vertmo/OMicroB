include ../../../etc/Makefile.conf

all: master.hex slave.hex

master.hex: master.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^

slave.hex: slave.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^

flash-slave: slave.hex
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo slave.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: all flash-master
