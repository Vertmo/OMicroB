include ../../../../etc/Makefile.conf

PROG = minicaml
EADK_APP_NAME = \"OCaml-MiniCaml\"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16192
HEAP_SIZE = 32768

TARGETS := $(PROG).hex $(PROG).elf

OCAMLOPT = ocamlopt.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): mml.ml interpreter.ml typechecker.ml mylexing.mli mylexing.ml mmlparser.mli mmlparser.ml mmllexer.ml minicaml.ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@


minicaml.exe:	mml.ml interpreter.ml typechecker.ml mylexing.mli mylexing.ml mmlparser.mli mmlparser.ml mmllexer.ml minicaml.ml
	@echo "OCAMLOPT $<"
	$(OCAMLOPT) -c mml.ml
	$(OCAMLOPT) -c interpreter.ml
	$(OCAMLOPT) -c typechecker.ml
	$(OCAMLOPT) -c mylexing.mli
	$(OCAMLOPT) -c mylexing.ml
	$(OCAMLOPT) -c mmlparser.mli
	$(OCAMLOPT) -c mmlparser.ml
	$(OCAMLOPT) -c mmllexer.ml

	$(OCAMLOPT) -o $@ mml.cmx interpreter.cmx typechecker.cmx mylexing.cmx mmlparser.cmx mmllexer.cmx minicaml.ml
	# To test what was produced:
	./minicaml.exe
	@echo "That test should print 832040."

mmli.exe:	mml.ml interpreter.ml typechecker.ml mylexing.mli mylexing.ml mmlparser.mli mmlparser.ml mmllexer.ml mmli.ml
	@echo "OCAMLOPT $<"
	$(OCAMLOPT) -c mml.ml
	$(OCAMLOPT) -c interpreter.ml
	$(OCAMLOPT) -c typechecker.ml
	$(OCAMLOPT) -c mylexing.mli
	$(OCAMLOPT) -c mylexing.ml
	$(OCAMLOPT) -c mmlparser.mli
	$(OCAMLOPT) -c mmlparser.ml
	$(OCAMLOPT) -c mmllexer.ml

	$(OCAMLOPT) -o $@ mml.cmx interpreter.cmx typechecker.cmx mylexing.cmx mmlparser.cmx mmllexer.cmx mmli.ml
	# To test what was produced:
	./tests_all.sh

.PHONY: run
clean:
	rm -vf *.cmi *.cmo *.cmx *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.elf *.bytecode *.o *.exe

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
