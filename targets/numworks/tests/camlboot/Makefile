#
# Makefile for the OMicroB-camlboot application
#
include ../../../../etc/Makefile.conf

APP_NAME = OMicroB-Camlboot
VERSION = 1.0
EADK_APP_NAME = \"$(APP_NAME)\"
PROG = $(APP_NAME)-$(VERSION)
DEVICE ?= numworks

# FIXME: find what is the upper limit for these? Apparently above 16192 it doesn't get flashed on the NumWorks flashing website
STACK_SIZE = 2000
# STACK_SIZE = 16192
# STACK_SIZE = 32384
# STACK_SIZE = 64768

# HEAP_SIZE = 8192
# HEAP_SIZE = 16192
# HEAP_SIZE = 28000
HEAP_SIZE = 35000
# HEAP_SIZE = 64768

TARGETS := $(PROG).byte $(PROG).hex $(PROG).elf

INCLUDES := -I stdlib/ -I parsing/ -I interpreter/
CINCLUDES := $(shell echo $(INCLUDES) | sed -e 's/ /,/g')
OMICROB_PARAMS := -v -mlopts $(CINCLUDES) -device=$(DEVICE)

OCAMLOPT = ocamlopt.opt

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
all: hex elf
	file $(PROG).byte
	file $(PROG).hex
	cp -vf $(PROG).hex $(PROG).nwa
	file $(PROG).nwa

.PHONY: hex
hex: $(PROG).hex
	cp -vf $(PROG).hex $(PROG).nwa

.PHONY: elf
elf: $(PROG).elf

$(TARGETS): $(CMOS)
	@echo "Compiling .cmo files to .byte"
	$(BIN)/omicrob -trace 0 $(OMICROB_PARAMS) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) $^ -o $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml $(CMIS)
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

.PHONY: clean
clean:
	rm -vf **/*.cm* *.byte *.c *.elf *.hex *nwa

.PHONY: flash
flash: $(PROG).hex
	$(BIN)/omicrob -device numworks -flash $^
