include ../../../etc/Makefile.conf

esp8266: light.ml
	$(BIN)/omicrob -v -device=wemos-d1-mini -circuitppx $^ -o light.esp_elf

uno: light.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o light.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo light.hex

flash-esp8266: esp8266
	$(BIN)/omicrob -v -device=wemos-d1-mini -flash -sudo light.esp_elf

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr *.esp_o *.esp_elf *.bin *.d

.PHONY: clean uno flash-uno
