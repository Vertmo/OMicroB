include ../../../../etc/Makefile.conf

PROG = ocaml-interpreter
EADK_APP_NAME = \"OCaml-Interpreter\"
DEVICE ?= numworks

# FIXME: find what is the upper limit for these?
STACK_SIZE = 16384  # 2^14
HEAP_SIZE = 16384   # 2^14

# FIXME: I obtained a segfault, apparently due to the M&C garbage collector, so let's try to other one (S&C), but it's much less efficient!
# Default strategy: Mark and Compact
GC_ALGO = MAC
# Other strategy:   Stop and Copy
GC_ALGO = SAC

TARGETS := $(PROG).hex $(PROG).elf

# TODO: find how to compile the requirements for the Toploop module, using omicrob

TOPLEVEL_DEP += ./stdlib/camlinternalFormatBasics.mli
TOPLEVEL_DEP += ./stdlib/camlinternalFormatBasics.ml
TOPLEVEL_DEP += ./stdlib/camlinternalFormat.mli
TOPLEVEL_DEP += ./stdlib/camlinternalFormat.ml
TOPLEVEL_DEP += ./stdlib/format.mli
TOPLEVEL_DEP += ./stdlib/format.ml
TOPLEVEL_DEP += ./stdlib/lexing.mli
TOPLEVEL_DEP += ./stdlib/lexing.ml
TOPLEVEL_DEP += ./stdlib/sys.mli
TOPLEVEL_DEP += ./stdlib/sys.ml
TOPLEVEL_DEP += ./stdlib/nativeint.mli
TOPLEVEL_DEP += ./stdlib/nativeint.ml
TOPLEVEL_DEP += ./stdlib/digest.mli
TOPLEVEL_DEP += ./stdlib/digest.ml
TOPLEVEL_DEP += ./stdlib/random.mli
TOPLEVEL_DEP += ./stdlib/random.ml
TOPLEVEL_DEP += ./stdlib/camlinternalLazy.mli
TOPLEVEL_DEP += ./stdlib/camlinternalLazy.ml
TOPLEVEL_DEP += ./stdlib/lazy.mli
TOPLEVEL_DEP += ./stdlib/lazy.ml
TOPLEVEL_DEP += ./stdlib/printf.mli
TOPLEVEL_DEP += ./stdlib/printf.ml
TOPLEVEL_DEP += ./stdlib/filename.mli
TOPLEVEL_DEP += ./stdlib/filename.ml
TOPLEVEL_DEP += ./stdlib/arg.mli
TOPLEVEL_DEP += ./stdlib/arg.ml
TOPLEVEL_DEP += ./stdlib/parsing.mli
TOPLEVEL_DEP += ./stdlib/parsing.ml
TOPLEVEL_DEP += ./stdlib/gc.mli
TOPLEVEL_DEP += ./stdlib/gc.ml
TOPLEVEL_DEP += ./stdlib/printexc.mli
TOPLEVEL_DEP += ./stdlib/printexc.ml
TOPLEVEL_DEP += ./stdlib/weak.mli
TOPLEVEL_DEP += ./stdlib/weak.ml
TOPLEVEL_DEP += ./stdlib/seq.mli
TOPLEVEL_DEP += ./stdlib/seq.ml
TOPLEVEL_DEP += ./stdlib/array.mli
TOPLEVEL_DEP += ./stdlib/array.ml
TOPLEVEL_DEP += ./stdlib/marshal.mli
TOPLEVEL_DEP += ./stdlib/marshal.ml

TOPLEVEL_DEP += ./utils/misc.mli
TOPLEVEL_DEP += ./utils/misc.ml
TOPLEVEL_DEP += ./utils/warnings.mli
TOPLEVEL_DEP += ./utils/warnings.ml
TOPLEVEL_DEP += ./utils/terminfo.mli
TOPLEVEL_DEP += ./utils/terminfo.ml
TOPLEVEL_DEP += ./utils/build_path_prefix_map.mli
TOPLEVEL_DEP += ./utils/build_path_prefix_map.ml
TOPLEVEL_DEP += ./utils/profile.mli
TOPLEVEL_DEP += ./utils/profile.ml
TOPLEVEL_DEP += ./utils/identifiable.mli
TOPLEVEL_DEP += ./utils/identifiable.ml
TOPLEVEL_DEP += ./utils/numbers.mli
TOPLEVEL_DEP += ./utils/numbers.ml
TOPLEVEL_DEP += ./utils/arg_helper.mli
TOPLEVEL_DEP += ./utils/arg_helper.ml
TOPLEVEL_DEP += ./utils/config.mli
TOPLEVEL_DEP += ./utils/config.ml
TOPLEVEL_DEP += ./utils/clflags.mli
TOPLEVEL_DEP += ./utils/clflags.ml
TOPLEVEL_DEP += ./utils/consistbl.mli
TOPLEVEL_DEP += ./utils/consistbl.ml
TOPLEVEL_DEP += ./utils/tbl.mli
TOPLEVEL_DEP += ./utils/tbl.ml

TOPLEVEL_DEP += ./parsing/longident.mli
TOPLEVEL_DEP += ./parsing/longident.ml
TOPLEVEL_DEP += ./parsing/location.mli
TOPLEVEL_DEP += ./parsing/location.ml
TOPLEVEL_DEP += ./parsing/asttypes.mli
TOPLEVEL_DEP += ./parsing/parsetree.mli
TOPLEVEL_DEP += ./parsing/attr_helper.mli
TOPLEVEL_DEP += ./parsing/attr_helper.ml
TOPLEVEL_DEP += ./parsing/docstrings.mli
TOPLEVEL_DEP += ./parsing/docstrings.ml
TOPLEVEL_DEP += ./parsing/syntaxerr.mli
TOPLEVEL_DEP += ./parsing/syntaxerr.ml
TOPLEVEL_DEP += ./parsing/ast_helper.mli
TOPLEVEL_DEP += ./parsing/ast_helper.ml
TOPLEVEL_DEP += ./parsing/ast_mapper.mli
TOPLEVEL_DEP += ./parsing/ast_mapper.ml
TOPLEVEL_DEP += ./parsing/builtin_attributes.mli
TOPLEVEL_DEP += ./parsing/builtin_attributes.ml
TOPLEVEL_DEP += ./parsing/parser.mli
TOPLEVEL_DEP += ./parsing/parser.ml
TOPLEVEL_DEP += ./parsing/lexer.mli
TOPLEVEL_DEP += ./parsing/lexer.ml
TOPLEVEL_DEP += ./parsing/ast_iterator.mli
TOPLEVEL_DEP += ./parsing/ast_iterator.ml
TOPLEVEL_DEP += ./parsing/parse.mli
TOPLEVEL_DEP += ./parsing/parse.ml
TOPLEVEL_DEP += ./parsing/printast.mli
TOPLEVEL_DEP += ./parsing/printast.ml

TOPLEVEL_DEP += ./typing/ident.mli
TOPLEVEL_DEP += ./typing/ident.ml
TOPLEVEL_DEP += ./typing/path.mli
TOPLEVEL_DEP += ./typing/path.ml
TOPLEVEL_DEP += ./typing/outcometree.mli
TOPLEVEL_DEP += ./typing/primitive.mli
TOPLEVEL_DEP += ./typing/primitive.ml
TOPLEVEL_DEP += ./typing/types.mli
TOPLEVEL_DEP += ./typing/types.ml
TOPLEVEL_DEP += ./typing/cmi_format.mli
TOPLEVEL_DEP += ./typing/cmi_format.ml
TOPLEVEL_DEP += ./typing/btype.mli
TOPLEVEL_DEP += ./typing/btype.ml
TOPLEVEL_DEP += ./typing/subst.mli
TOPLEVEL_DEP += ./typing/subst.ml
TOPLEVEL_DEP += ./typing/datarepr.mli
TOPLEVEL_DEP += ./typing/datarepr.ml
TOPLEVEL_DEP += ./typing/predef.mli
TOPLEVEL_DEP += ./typing/predef.ml
TOPLEVEL_DEP += ./typing/env.mli
TOPLEVEL_DEP += ./typing/env.ml
TOPLEVEL_DEP += ./typing/typedtree.mli
TOPLEVEL_DEP += ./typing/typedtree.ml
TOPLEVEL_DEP += ./typing/ctype.mli
TOPLEVEL_DEP += ./typing/ctype.ml
TOPLEVEL_DEP += ./typing/includecore.mli
TOPLEVEL_DEP += ./typing/includecore.ml
TOPLEVEL_DEP += ./typing/tast_mapper.mli
TOPLEVEL_DEP += ./typing/tast_mapper.ml
TOPLEVEL_DEP += ./typing/cmt_format.mli
TOPLEVEL_DEP += ./typing/cmt_format.ml
TOPLEVEL_DEP += ./typing/oprint.mli
TOPLEVEL_DEP += ./typing/oprint.ml
TOPLEVEL_DEP += ./typing/printtyp.mli
TOPLEVEL_DEP += ./typing/printtyp.ml
TOPLEVEL_DEP += ./typing/includeclass.mli
TOPLEVEL_DEP += ./typing/includeclass.ml
TOPLEVEL_DEP += ./typing/mtype.mli
TOPLEVEL_DEP += ./typing/mtype.ml
TOPLEVEL_DEP += ./typing/includemod.mli
TOPLEVEL_DEP += ./typing/includemod.ml
TOPLEVEL_DEP += ./typing/typetexp.mli
TOPLEVEL_DEP += ./typing/typetexp.ml
TOPLEVEL_DEP += ./typing/typedecl.mli
TOPLEVEL_DEP += ./typing/typedecl.ml

TOPLEVEL_DEP += ./bytecomp/lambda.mli
TOPLEVEL_DEP += ./bytecomp/lambda.ml
TOPLEVEL_DEP += ./typing/typeopt.mli
TOPLEVEL_DEP += ./typing/typeopt.ml

TOPLEVEL_DEP += ./bytecomp/dll.mli
TOPLEVEL_DEP += ./bytecomp/dll.ml
TOPLEVEL_DEP += ./bytecomp/cmo_format.mli
TOPLEVEL_DEP += ./bytecomp/runtimedef.mli
TOPLEVEL_DEP += ./bytecomp/runtimedef.ml
TOPLEVEL_DEP += ./bytecomp/instruct.mli
TOPLEVEL_DEP += ./bytecomp/instruct.ml
TOPLEVEL_DEP += ./bytecomp/meta.mli
TOPLEVEL_DEP += ./bytecomp/meta.ml
TOPLEVEL_DEP += ./bytecomp/bytesections.mli
TOPLEVEL_DEP += ./bytecomp/bytesections.ml
TOPLEVEL_DEP += ./bytecomp/symtable.mli
TOPLEVEL_DEP += ./bytecomp/symtable.ml

TOPLEVEL_DEP += ./typing/annot.mli
TOPLEVEL_DEP += ./typing/stypes.mli
TOPLEVEL_DEP += ./typing/stypes.ml
TOPLEVEL_DEP += ./typing/untypeast.mli
TOPLEVEL_DEP += ./typing/untypeast.ml
TOPLEVEL_DEP += ./typing/printpat.mli
TOPLEVEL_DEP += ./typing/printpat.ml
TOPLEVEL_DEP += ./typing/typedtreeIter.mli
TOPLEVEL_DEP += ./typing/typedtreeIter.ml
TOPLEVEL_DEP += ./typing/parmatch.mli
TOPLEVEL_DEP += ./typing/parmatch.ml
TOPLEVEL_DEP += ./typing/typecore.mli
TOPLEVEL_DEP += ./typing/typecore.ml
TOPLEVEL_DEP += ./typing/typeclass.mli
TOPLEVEL_DEP += ./typing/typeclass.ml
TOPLEVEL_DEP += ./typing/typemod.mli
TOPLEVEL_DEP += ./typing/typemod.ml
TOPLEVEL_DEP += ./typing/printtyped.mli
TOPLEVEL_DEP += ./typing/printtyped.ml

TOPLEVEL_DEP += ./bytecomp/printlambda.mli
TOPLEVEL_DEP += ./bytecomp/printlambda.ml
TOPLEVEL_DEP += ./bytecomp/switch.mli
TOPLEVEL_DEP += ./bytecomp/switch.ml
TOPLEVEL_DEP += ./bytecomp/matching.mli
TOPLEVEL_DEP += ./bytecomp/matching.ml
TOPLEVEL_DEP += ./bytecomp/translprim.mli
TOPLEVEL_DEP += ./bytecomp/translprim.ml
TOPLEVEL_DEP += ./bytecomp/translattribute.mli
TOPLEVEL_DEP += ./bytecomp/translattribute.ml
TOPLEVEL_DEP += ./bytecomp/translobj.mli
TOPLEVEL_DEP += ./bytecomp/translobj.ml
TOPLEVEL_DEP += ./bytecomp/translcore.mli
TOPLEVEL_DEP += ./bytecomp/translcore.ml
TOPLEVEL_DEP += ./bytecomp/translclass.mli
TOPLEVEL_DEP += ./bytecomp/translclass.ml
TOPLEVEL_DEP += ./bytecomp/translmod.mli
TOPLEVEL_DEP += ./bytecomp/translmod.ml
TOPLEVEL_DEP += ./bytecomp/simplif.mli
TOPLEVEL_DEP += ./bytecomp/simplif.ml
TOPLEVEL_DEP += ./bytecomp/bytegen.mli
TOPLEVEL_DEP += ./bytecomp/bytegen.ml
TOPLEVEL_DEP += ./bytecomp/printinstr.mli
TOPLEVEL_DEP += ./bytecomp/printinstr.ml
TOPLEVEL_DEP += ./bytecomp/opcodes.ml
TOPLEVEL_DEP += ./bytecomp/emitcode.mli
TOPLEVEL_DEP += ./bytecomp/emitcode.ml

TOPLEVEL_DEP += ./utils/ccomp.mli
TOPLEVEL_DEP += ./utils/ccomp.ml
TOPLEVEL_DEP += ./parsing/ast_invariants.mli
TOPLEVEL_DEP += ./parsing/ast_invariants.ml
TOPLEVEL_DEP += ./driver/pparse.mli
TOPLEVEL_DEP += ./driver/pparse.ml
TOPLEVEL_DEP += ./parsing/pprintast.mli
TOPLEVEL_DEP += ./parsing/pprintast.ml
TOPLEVEL_DEP += ./stdlib/scanf.mli
TOPLEVEL_DEP += ./stdlib/scanf.ml
TOPLEVEL_DEP += ./driver/compenv.mli
TOPLEVEL_DEP += ./driver/compenv.ml
TOPLEVEL_DEP += ./driver/compmisc.mli
TOPLEVEL_DEP += ./driver/compmisc.ml

TOPLEVEL_DEP += ./toplevel/genprintval.mli
TOPLEVEL_DEP += ./toplevel/genprintval.ml
TOPLEVEL_DEP += ./toplevel/toploop.mli
TOPLEVEL_DEP += ./toplevel/toploop.ml

OCAMLOPT = ocamlopt.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

$(TARGETS): $(TOPLEVEL_DEP) interpreter.ml
	@echo "omicrob to generate $@"
	$(BIN)/omicrob -v -gc $(GC_ALGO) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -mlopts -I,stdlib/,-I,utils/,-I,parsing/,-I,typing/,-I,bytecomp/,-I,driver/,-I,toplevel/ -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE) $^ -o $@

.PHONY: interpreter.byte
interpreter.byte: interpreter.ml
	@echo "Compiling 'interpreter.byte' ..."
	ocamlbuild -no-hygiene -classic-display -r interpreter.byte -pkgs compiler-libs,compiler-libs.toplevel
	mv -vf ./interpreter.byte ./interpreter.ocamlbuild.byte
	@echo "Testing 'interpreter.ocamlbuild.byte' ..."
	./interpreter.ocamlbuild.byte

.PHONY: clean
clean:
	rm -vI ./*.cmi ./*.cmo ./*.cmx ./*.byte ./*.c ./*.arm_o ./*.elf ./*.arm_elf ./*.hex ./*.nwa ./*.elf ./*.bytecode ./*.o ./*.exe
	rm -vI ./*/*.cmi ./*/*.cmo

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
