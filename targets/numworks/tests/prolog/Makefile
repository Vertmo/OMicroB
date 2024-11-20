include ../../../../etc/Makefile.conf

PROG = prolog
EADK_APP_NAME = \"OCaml-Prolog\"
DEVICE ?= numworks

# FIXME: my examples of recursive functions broke quite quickly, do they perform better with an increased STACK_SIZE and HEAP_SIZE ?
STACK_SIZE = 2048  # 2^11
HEAP_SIZE = 8192   # 2^13

TARGETS := $(PROG).hex $(PROG).elf

OCAMLOPT = ocamlopt.opt
OCAMLC = ocamlc.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): mystream.mli mystream.ml mygenlex.mli mygenlex.ml $(PROG).ml
	@echo "omicrob $<"
	$(BIN)/omicrob -v -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

$(PROG).exe:	$(PROG).ml
	@echo "OCAMLOPT $<"
	$(OCAMLOPT) -c mystream.mli
	$(OCAMLOPT) -c mystream.ml
	$(OCAMLOPT) -c mygenlex.mli
	$(OCAMLOPT) -c mygenlex.ml
	$(OCAMLOPT) -o $@ mygenlex.cmx $^
	# To test what was produced:
	./$@

$(PROG).bytecode:	$(PROG).ml mygenlex.ml
	@echo "OCAMLC $<"
	$(OCAMLC) -c mygenlex.mli
	$(OCAMLC) -c mygenlex.ml
	$(OCAMLC) -o $@ mygenlex.cmo $^
	# To test what was produced:
	./$@

.PHONY: clean
clean:
	rm -vf *.cmi *.cmo *.cmx *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.nwa *.elf *.bytecode *.o *.exe

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
