include ../../../etc/Makefile.conf

all: referee.combined_hex playerRad.combined_hex playerSpi.hex

referee.combined_hex: referee.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o $@ -heap-size=430

playerRad.combined_hex: playerRad.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@ -heap-size=400

playerSpi.hex: playerSpi.ml
	$(BIN)/omicrob -v -device=arduino-uno $^ -circuitppx -heap-size=200

flash-uno: playerSpi.hex
	$(BIN)/omicrob -v -device=arduino-uno $^ -flash

clean:
	rm *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex
