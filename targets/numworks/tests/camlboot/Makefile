include ../../../../etc/Makefile.conf

VERSION = 0.0.1
EADK_APP_NAME = OMicroB-camlboot
PROG = $(EADK_APP_NAME)-$(VERSION)
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16192
HEAP_SIZE = 8192

TARGETS := $(PROG).hex $(PROG).elf

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
all: $(PROG).hex
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(CMOS) camlboot.cmo
	@echo "Compiling .cmo files to .byte"
	$(BIN)/omicrob $(OMICROB_PARAMS) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) $^ -o $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml $(CMIS)
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

.PHONY: clean
clean:
	rm -vf **/*.cm*

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
