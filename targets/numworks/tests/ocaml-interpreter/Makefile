include ../../../../etc/Makefile.conf

PROG = ocaml-interpreter
EADK_APP_NAME = \"OCaml-Interpreter\"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16384
HEAP_SIZE = 16384

# FIXME: I obtained a segfault, apparently due to the M&C garbage collector, so let's try to other one (S&C)
GC_ALGO = MAC  # Default strategy: Mark and Compact
GC_ALGO = SAC  # Other strategy:   Stop and Copy

TARGETS := $(PROG).hex $(PROG).elf

# TODO: find how to compile the requirements for the Toploop module, using omicrob

# TOPLEVEL_DEP += ./stdlib/int.mli
# TOPLEVEL_DEP += ./stdlib/int.ml
# TOPLEVEL_DEP += ./stdlib/camlinternalFormatBasics.mli
# TOPLEVEL_DEP += ./stdlib/camlinternalFormatBasics.ml
# TOPLEVEL_DEP += ./stdlib/camlinternalFormat.mli
# TOPLEVEL_DEP += ./stdlib/camlinternalFormat.ml
# TOPLEVEL_DEP += ./stdlib/format.mli
# TOPLEVEL_DEP += ./stdlib/format.ml

# TOPLEVEL_DEP += ./toplevel/topmain.mli
# TOPLEVEL_DEP += ./toplevel/topmain.ml
# TOPLEVEL_DEP += ./toplevel/trace.mli
# TOPLEVEL_DEP += ./toplevel/trace.ml
# TOPLEVEL_DEP += ./toplevel/topeval.mli
# TOPLEVEL_DEP += ./toplevel/topeval.ml
# TOPLEVEL_DEP += ./toplevel/topstart.ml
# TOPLEVEL_DEP += ./toplevel/topdirs.mli
# TOPLEVEL_DEP += ./toplevel/topdirs.ml
# TOPLEVEL_DEP += ./toplevel/genprintval.mli
# TOPLEVEL_DEP += ./toplevel/genprintval.ml
# TOPLEVEL_DEP += ./toplevel/topcommon.mli
# TOPLEVEL_DEP += ./toplevel/topcommon.ml
TOPLEVEL_DEP += ./toplevel/toploop.mli
TOPLEVEL_DEP += ./toplevel/toploop.ml

OCAMLOPT = ocamlopt.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(TOPLEVEL_DEP) mylexing.mli mylexing.ml interpreter.ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -gc $(GC_ALGO) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopts -I,stdlib/,-I,compiler-libs/ -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

.PHONY: interpreter.byte
interpreter.byte: interpreter.ml
	@echo "Compiling 'interpreter.byte' ..."
	ocamlbuild -no-hygiene -classic-display -r interpreter.byte -pkgs compiler-libs,compiler-libs.toplevel
	mv -vf ./interpreter.byte ./interpreter.ocamlbuild.byte
	@echo "Testing 'interpreter.ocamlbuild.byte' ..."
	./interpreter.ocamlbuild.byte

.PHONY: clean
clean:
	rm -vf *.cmi *.cmo *.cmx *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.elf *.bytecode *.o *.exe

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
