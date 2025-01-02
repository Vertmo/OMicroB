include ../../../../etc/Makefile.conf

PROG = interpreter
EADK_APP_NAME = \"OCaml-Interpreter\"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16384  # 2^14
HEAP_SIZE = 16384   # 2^14

GC_ALGO = MAC

TARGETS := $(PROG).hex $(PROG).elf

INCLUDES := -I stdlib/ -I utils/ -I parsing/ -I typing/ -I bytecomp/ -I driver/ -I toplevel/
CINCLUDES := $(shell echo $(INCLUDES) | sed -e 's/ /,/g')
OMICROB_PARAMS := -v -mlopts $(CINCLUDES) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE)

SRCS += stdlib/*.mli stdlib/*.ml
SRCS += utils/*.mli utils/*.ml
SRCS += parsing/*.mli parsing/*.ml
SRCS += typing/*.mli typing/*.ml
SRCS += bytecomp/*.mli bytecomp/*.ml
SRCS += driver/*.mli driver/*.ml
SRCS += toplevel/*.mli toplevel/*.ml

SSRCS = $(shell ocamldep -bytecode -sort $(INCLUDES) $(SRCS))

MLS = $(filter %.ml,$(SSRCS))
CMOS = $(patsubst %.ml,%.cmo, $(MLS))

OCAMLOPT = ocamlopt.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(CMOS) interpreter.cmo
	@echo "omicrob to generate $@"
	$(BIN)/omicrob $(OMICROB_PARAMS) -gc $(GC_ALGO) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) $^ -o $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

# Dependencies
interpreter.d: $(SRCS)
	ocamldep -bytecode $(INCLUDES) $^ > interpreter.d

include interpreter.d

# Clean
.PHONY: clean
clean:
	rm -rf *.cmi *.cmo *.cmx *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.elf *.bytecode *.o *.exe interpreter.d
	rm -rf **/*.cmi **/*.cmo

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
