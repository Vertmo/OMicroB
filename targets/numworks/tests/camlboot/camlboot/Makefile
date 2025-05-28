BOOT=_boot
OCAMLSRC=ocaml-src
CONFIG=$(OCAMLSRC)/Makefile.config
OCAMLRUN=$(OCAMLSRC)/runtime/ocamlrun
GENERATED=$(OCAMLSRC)/bytecomp/opcodes.ml

$(OCAMLRUN): $(CONFIG)
	touch $(OCAMLSRC)/runtime/.depend && $(MAKE) -C $(OCAMLSRC)/runtime depend
	$(MAKE) -C $(OCAMLSRC)/runtime all
	cp $(OCAMLSRC)/runtime/ocamlrun $(OCAMLSRC)/boot/

.PHONY: configure-ocaml
configure-ocaml:
	rm -f $(OCAMLSRC)/boot/ocamlc $(OCAMLSRC)/boot/ocamllex
	find $(OCAMLSRC) -iname .depend | xargs rm -f
	touch $(OCAMLSRC)/.depend $(OCAMLSRC)/stdlib/.depend $(OCAMLSRC)/lex/.depend
	cd $(OCAMLSRC) && bash configure
	$(MAKE) -C $(OCAMLSRC) ocamlyacc && cp $(OCAMLSRC)/yacc/ocamlyacc $(OCAMLSRC)/boot
	$(MAKE) -C $(OCAMLSRC)/lex parser.ml

.PHONY: ocaml-parser
ocaml-parser:
	# first we compile parser.mly
	menhir --explain --dump --lalr --strict --table -lg 1 -la 1 --unused-token COMMENT --unused-token DOCSTRING --unused-token EOL --unused-token GREATERRBRACKET --fixed-exception $(OCAMLSRC)/parsing/parser.mly
	# then populate boot/menhir with the generated parser, and the menhir library source
	cp $(OCAMLSRC)/parsing/parser.ml{,i} $(OCAMLSRC)/boot/menhir/
	cp $(addprefix `menhir --suggest-menhirLib`/menhirLib.,ml mli) $(OCAMLSRC)/boot/menhir
	# then: copy boot/menhir content in the repository tree
	cp $(OCAMLSRC)/boot/menhir/menhirLib.ml $(OCAMLSRC)/parsing/camlinternalMenhirLib.ml
	cp $(OCAMLSRC)/boot/menhir/menhirLib.mli $(OCAMLSRC)/parsing/camlinternalMenhirLib.mli
	chmod +w $(OCAMLSRC)/parsing/parser.ml{,i}
	sed "s/MenhirLib/CamlinternalMenhirLib/g" $(OCAMLSRC)/boot/menhir/parser.ml > $(OCAMLSRC)/parsing/parser.ml
	sed "s/MenhirLib/CamlinternalMenhirLib/g" $(OCAMLSRC)/boot/menhir/parser.mli > $(OCAMLSRC)/parsing/parser.mli

# Here, including $(CONFIG) would provide $(ARCH), but it leads to a recursive
# dependency because its rule has a dependency that reloads this Makefile.
.PHONY: ocaml-generated-files
ocaml-generated-files: $(OCAMLRUN) lex make_opcodes cvt_emit ocaml-parser
	$(MAKE) -C $(OCAMLSRC)/stdlib sys.ml
	$(MAKE) -C $(OCAMLSRC) utils/config.ml
	cd $(OCAMLSRC); ../miniml/interp/lex.sh parsing/lexer.mll
	$(MAKE) -C $(OCAMLSRC) lambda/runtimedef.ml
	miniml/interp/make_opcodes.sh -opcodes < $(OCAMLSRC)/runtime/caml/instruct.h > $(OCAMLSRC)/bytecomp/opcodes.ml
	$(MAKE) -C $(OCAMLSRC) asmcomp/arch.ml asmcomp/proc.ml asmcomp/selection.ml asmcomp/CSE.ml asmcomp/reload.ml asmcomp/scheduling.ml
	miniml/interp/cvt_emit.sh < $(OCAMLSRC)/asmcomp/$(shell cat $(CONFIG) | grep '^ARCH=' | cut -f2 -d=)/emit.mlp > $(OCAMLSRC)/asmcomp/emit.ml

.PHONY: lex
lex: $(OCAMLRUN)
	touch miniml/interp/.depend
	$(MAKE) -C miniml/interp lex.byte

.PHONY: make_opcodes
make_opcodes: $(OCAMLRUN) lex
	$(MAKE) -C miniml/interp make_opcodes.byte

.PHONY: cvt_emit
cvt_emit: $(OCAMLRUN) lex
	$(MAKE) -C miniml/interp cvt_emit.byte

.PHONY: makedepend
makedepend: $(OCAMLRUN) lex
	$(MAKE) -C miniml/interp makedepend.byte

.PHONY: clean-ocaml-config
clean-ocaml-config:
	cd $(OCAMLSRC) && make distclean

# this dependency is fairly coarse-grained, so feel free to
# use clean-ocaml-config if make a small change to $(OCAMLSRC)
# that you believe does require re-configuring.
$(CONFIG): $(OCAMLSRC)/VERSION
	$(MAKE) configure-ocaml

$(GENERATED): $(OCAMLRUN) lex make_opcodes
	$(MAKE) ocaml-generated-files

$(BOOT)/driver: $(OCAMLSRC)/driver $(OCAMLSRC)/otherlibs/dynlink $(CONFIG) $(GENERATED)
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@
	cp $(OCAMLSRC)/otherlibs/dynlink/dynlink.mli $@/compdynlink.mli
	cp $(OCAMLSRC)/otherlibs/dynlink/byte/dynlink.ml $@/compdynlink.ml

$(BOOT)/bytecomp: $(OCAMLSRC)/bytecomp $(CONFIG) $(GENERATED)
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@

$(BOOT)/typing: $(OCAMLSRC)/typing $(CONFIG) $(GENERATED)
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@

$(BOOT)/parsing: $(OCAMLSRC)/parsing $(CONFIG) $(GENERATED) patches/parsetree.patch lex
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@
	#patch $(BOOT)/parsing/parsetree.mli patches/parsetree.patch

$(BOOT)/utils: $(OCAMLSRC)/utils $(CONFIG) $(GENERATED) patches/disable-profiling.patch
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@
	cp $(BOOT)/utils/profile.ml $(BOOT)/utils/profile.ml.noprof
	patch $(BOOT)/utils/profile.ml.noprof patches/disable-profiling.patch

$(BOOT)/stdlib: $(OCAMLSRC)/stdlib $(CONFIG) $(GENERATED) patches/compflags.patch
	mkdir -p $(BOOT)
	rm -rf $@
	cp -r $< $@
	patch $(BOOT)/stdlib/Compflags patches/compflags.patch
	awk -f $(BOOT)/stdlib/expand_module_aliases.awk < $(BOOT)/stdlib/stdlib.mli > $(BOOT)/stdlib/stdlib.pp.mli
	awk -f $(BOOT)/stdlib/expand_module_aliases.awk < $(BOOT)/stdlib/stdlib.ml > $(BOOT)/stdlib/stdlib.pp.ml
	$(MAKE) -C $(OCAMLSRC) runtime/libasmrun.a
	cp $(OCAMLSRC)/runtime/libasmrun.a $(BOOT)/stdlib/
	cp Makefile.stdlib $(BOOT)/stdlib/Makefile

COPY_TARGETS=\
	$(BOOT)/bytecomp \
	$(BOOT)/driver \
	$(BOOT)/parsing \
	$(BOOT)/stdlib \
	$(BOOT)/typing \
	$(BOOT)/utils

.PHONY: copy
copy: $(COPY_TARGETS)
	cp Makefile.ocamlc $(BOOT)/Makefile

.PHONY: ocamlrun
ocamlrun: $(OCAMLRUN)

$(BOOT)/ocamlc: copy makedepend
	$(MAKE) -C $(OCAMLSRC)/yacc all
	$(MAKE) -C miniml/interp depend
	./timed.sh $(MAKE) $(MAKEFLAGS) -C miniml/interp interpopt.opt
	touch _boot/stdlib/.depend && $(MAKE) -C _boot/stdlib depend
	touch _boot/.depend && $(MAKE) -C _boot depend
	./timed.sh $(MAKE) $(MAKEFLAGS) -C _boot/stdlib all
	# cd $(BOOT)/stdlib && ../../timed.sh ../../compile_stdlib.sh
	mkdir -p $(BOOT)/compilerlibs
	./timed.sh $(MAKE) $(MAKEFLAGS) -C _boot ocamlc
	# cd $(BOOT) && ../timed.sh ../compile_ocamlc.sh

# Remove dependency on $(BOOT)/ocamlc, because it seems to cause ocamlc to be rebuilt even if it was just built
fullboot:
	cp $(BOOT)/ocamlc $(OCAMLSRC)/boot/
	cp miniml/interp/lex.byte $(OCAMLSRC)/boot/ocamllex
	cp $(OCAMLRUN) $(OCAMLSRC)/boot/ocamlrun$(EXE)
	touch $(OCAMLSRC)/stdlib/.depend && ./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC)/stdlib CAMLDEP="../boot/ocamlc -depend" depend
	./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC)/stdlib COMPILER="" CAMLC="../boot/ocamlc -use-prims ../runtime/primitives" all
	cd $(OCAMLSRC)/stdlib; cp stdlib.cma std_exit.cmo *.cmi camlheader ../boot
	cd $(OCAMLSRC)/boot; ln -sf ../runtime/libcamlrun.a .
	touch $(OCAMLSRC)/tools/.depend &&  ./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC)/tools CAMLC="../boot/ocamlc -nostdlib -I ../boot -use-prims ../runtime/primitives -I .." make_opcodes cvt_emit
	touch $(OCAMLSRC)/lex/.depend && ./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC)/lex CAMLDEP="../boot/ocamlc -depend" depend
	./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC) CAMLDEP="boot/ocamlc -depend" depend
	./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC) CAMLC="boot/ocamlc -nostdlib -I boot -use-prims runtime/primitives" ocamlc
	./timed.sh $(MAKE) $(MAKEFLAGS) -C $(OCAMLSRC)/lex CAMLC="../boot/ocamlc -strict-sequence -nostdlib -I ../boot -use-prims ../runtime/primitives" all

.PHONY: test-compiler
test-compiler: $(OCAMLRUN)
	$(MAKE) -C miniml/compiler/test all OCAMLRUN=../../../$(OCAMLRUN)

.PHONY: test-compiler-promote
test-compiler-promote: $(OCAMLRUN)
	$(MAKE) -C miniml/compiler/test promote OCAMLRUN=../../../$(OCAMLRUN)
