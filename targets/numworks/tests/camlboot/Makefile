include ../../../../etc/Makefile.conf

PROG = interp
EADK_APP_NAME = "camlboot"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
HEAP_SIZE = 16192
STACK_SIZE = 2048

TARGETS := $(PROG).byte $(PROG).hex $(PROG).elf

INCLUDES := -I stdlib/ -I parsing/ -I interpreter/
CINCLUDES := $(shell echo $(INCLUDES) | sed -e 's/ /,/g')
OMICROB_PARAMS := -v -mlopts $(CINCLUDES) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE)

OCAMLOPT = ocamlopt.opt

# Define intermediate files
BYTECODE = interp.byte
C_SOURCE = interp.c

# Directory containing the source files
SRCS += stdlib/*.mli stdlib/*.ml
SRCS += parsing/*.mli parsing/*.ml
SRCS += interpreter/*.mli interpreter/*.ml

SSRCS = $(shell ocamldep -bytecode -sort $(INCLUDES) $(SRCS))

MLS = $(filter %.ml,$(SSRCS))
CMOS = $(patsubst %.ml,%.cmo,$(MLS))
MLIS = $(filter %.mli,$(SSRCS))
CMIS = $(patsubst %.mli,%.cmi,$(MLIS))

.PHONY: all

all: $(PROG).nwa $(PROG).elf

%.nwa: %.hex
	cp -vf $^ $@

$(TARGETS): $(CMOS)
	@echo "Compiling .cmo files to .byte"
	$(BIN)/omicrob -trace 0 $(OMICROB_PARAMS) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) $^ -o $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml $(CMIS)
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

.PHONY: clean
clean:
	rm -vf **/*.cm* *.byte *.elf *.hex *.nwa

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
