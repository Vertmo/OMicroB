include ../../../etc/Makefile.conf

all: referee.combined_hex player.combined_hex

referee.combined_hex: referee.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@ -heap-size=420

player.combined_hex: player.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@ -heap-size=400

clean:
	rm *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
