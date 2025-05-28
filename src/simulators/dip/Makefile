include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_pin_simulator

dip: $(TARG)

$(TARG): main.ml
	ocamlfind ocamlopt -linkpkg -package graphics -thread \
	-I $(SRC)/simulators \
	simul.cmx simul_config.cmxa $^ -o $@

clean:
	@rm -f *~ *.o *.cmi *.cmx $(TARG)

.PHONY: dip clean
