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
SRCS += interpreter/*.mli interpreter/*.ml

SSRCS = $(shell ocamldep -bytecode -sort $(INCLUDES) $(SRCS))

MLS = $(filter %.ml,$(SSRCS))
CMOS = $(patsubst %.ml,%.cmo, $(MLS))

.PHONY: all
all: $(PROG).hex
	cp -vf $(PROG).hex $(PROG).nwa

# Step 1: Compile .cmo files to .byte using ocamlc
$(TARGETS): $(CMOS) camlboot.cmo
	@echo "Compiling .cmo files to .byte"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

.PHONY: clean
clean:
	rm -vf $(SRC_DIR)/*.byte $(SRC_DIR)/*.c  $(SRC_DIR)/*.hex $(SRC_DIR)/*.nwa $(SRC_DIR)/*.elf $(SRC_DIR)/*.bytecode $(SRC_DIR)/*.exe

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
