include ../../../../etc/Makefile.conf

PROG = interp
EADK_APP_NAME = "camlboot"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16192
HEAP_SIZE = 2048

TARGETS := $(PROG).hex $(PROG).elf

OCAMLOPT = ocamlopt.opt

# Define intermediate files
BYTECODE = interp.byte
C_SOURCE = interp.c

# Directory containing the source files
SRC_DIR = camlboot/interpreter

.PHONY: all
all: $(PROG).hex
	cp -vf $(PROG).hex $(PROG).nwa

# Step 1: Compile .cmo files to .byte using ocamlc
$(BYTECODE): $(SRC_DIR)/data.cmo $(SRC_DIR)/envir.cmo $(SRC_DIR)/eval.cmo $(SRC_DIR)/interp.cmo $(SRC_DIR)/primitives.cmo $(SRC_DIR)/runtime_base.cmo $(SRC_DIR)/runtime_compiler.cmo $(SRC_DIR)/runtime_lib.cmo $(SRC_DIR)/runtime_stdlib.cmo
	@echo "Compiling .cmo files to .byte"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

# Step 2: Compile .byte to .c using bc2c
$(C_SOURCE): $(BYTECODE)
	@echo "Compiling .byte to .c"
	$(BIN)/omicrob -v $(BYTECODE) -o $@

# Step 3: Compile .c to .elf using c++
$(PROG).elf: $(C_SOURCE)
	@echo "Compiling .c to .elf"
	$(BIN)/omicrob -v $(C_SOURCE) -o $@

# Step 4: Compile .c to .hex using architecture-specific chain
$(PROG).hex: $(C_SOURCE)
	@echo "Compiling .c to .hex"
	$(BIN)/omicrob -v $(C_SOURCE) -o $@

.PHONY: clean
clean:
	rm -vf $(SRC_DIR)/*.byte $(SRC_DIR)/*.c  $(SRC_DIR)/*.hex $(SRC_DIR)/*.nwa $(SRC_DIR)/*.elf $(SRC_DIR)/*.bytecode $(SRC_DIR)/*.exe

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<