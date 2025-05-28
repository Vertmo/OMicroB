
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_circuit_simulator
SRCS = $(wildcard *.ml *.mli *.mll)
BUILD = main.native
EXTRA = $(SRC)/simulators
CFLAGS = -thread,-I,$(EXTRA),-I,+../graphics
LFLAGS = $(CFLAGS),graphics.cmxa,simul.cmx,simul_config.cmxa #,$(LCD_MODS)
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

simu_circuit: $(TARG)

$(TARG): .build/$(BUILD)
	cp $< $@

.build/$(BUILD): $(SRCS) config.ml
	@rm -f $@
	$(OCAMLBUILD) -use-ocamlfind -use-menhir -package graphics $(OPTIONS) $(BUILD)
	@touch $@

config.ml: $(ETC)/config.ml
	cp $< $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ $(TARG)

.PHONY: simu_circuit clean
