include ../../../etc/Makefile.conf

esp8266: display.ml
	$(BIN)/omicrob -v -device=wemos-d1-mini -circuitppx $^ -o display.esp_elf

uno: display.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o display.hex

flash-esp8266: esp8266
	$(BIN)/omicrob -v -device=wemos-d1-mini -flash -sudo display.esp_elf

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo display.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr *.esp_o *.esp_elf *.bin *.d

.PHONY: clean uno flash-uno
