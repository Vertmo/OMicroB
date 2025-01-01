include ../../../../etc/Makefile.conf

PROG = interpreter
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

INCLUDES := -I stdlib/ -I utils/ -I parsing/ -I typing/ -I bytecomp/ -I driver/ -I toplevel/
CINCLUDES := $(shell echo $(INCLUDES) | sed -e 's/ /,/g')
OMICROB_PARAMS := -v -mlopts $(CINCLUDES) -mlopt=-ccopt=-DEADK_APP_NAME=$(EADK_APP_NAME) -device=$(DEVICE)

SRCS += ./stdlib/sys.mli
SRCS += ./stdlib/sys.ml
SRCS += ./stdlib/camlinternalFormatBasics.mli
SRCS += ./stdlib/camlinternalFormatBasics.ml
SRCS += ./stdlib/camlinternalFormat.mli
SRCS += ./stdlib/camlinternalFormat.ml
SRCS += ./stdlib/format.mli
SRCS += ./stdlib/format.ml
SRCS += ./stdlib/lexing.mli
SRCS += ./stdlib/lexing.ml
SRCS += ./stdlib/digest.mli
SRCS += ./stdlib/digest.ml
SRCS += ./stdlib/camlinternalLazy.mli
SRCS += ./stdlib/camlinternalLazy.ml
SRCS += ./stdlib/lazy.mli
SRCS += ./stdlib/lazy.ml
SRCS += ./stdlib/printf.mli
SRCS += ./stdlib/printf.ml
SRCS += ./stdlib/printexc.mli
SRCS += ./stdlib/printexc.ml
SRCS += ./stdlib/seq.mli
SRCS += ./stdlib/seq.ml
SRCS += ./stdlib/array.mli
SRCS += ./stdlib/array.ml
SRCS += ./stdlib/filename.mli
SRCS += ./stdlib/filename.ml
SRCS += ./stdlib/arg.mli
SRCS += ./stdlib/arg.ml
SRCS += ./stdlib/parsing.mli
SRCS += ./stdlib/parsing.ml
SRCS += ./stdlib/weak.mli
SRCS += ./stdlib/weak.ml

SRCS += ./utils/misc.mli
SRCS += ./utils/misc.ml
SRCS += ./utils/warnings.mli
SRCS += ./utils/warnings.ml
SRCS += ./utils/terminfo.mli
SRCS += ./utils/terminfo.ml
SRCS += ./utils/build_path_prefix_map.mli
SRCS += ./utils/build_path_prefix_map.ml
SRCS += ./utils/identifiable.mli
SRCS += ./utils/identifiable.ml
SRCS += ./utils/numbers.mli
SRCS += ./utils/numbers.ml
SRCS += ./utils/arg_helper.mli
SRCS += ./utils/arg_helper.ml
SRCS += ./utils/config.mli
SRCS += ./utils/config.ml
SRCS += ./utils/clflags.mli
SRCS += ./utils/clflags.ml
SRCS += ./utils/consistbl.mli
SRCS += ./utils/consistbl.ml
SRCS += ./utils/tbl.mli
SRCS += ./utils/tbl.ml

SRCS += ./parsing/longident.mli
SRCS += ./parsing/longident.ml
SRCS += ./parsing/location.mli
SRCS += ./parsing/location.ml
SRCS += ./parsing/asttypes.mli
SRCS += ./parsing/parsetree.mli
SRCS += ./parsing/attr_helper.mli
SRCS += ./parsing/attr_helper.ml
SRCS += ./parsing/docstrings.mli
SRCS += ./parsing/docstrings.ml
SRCS += ./parsing/syntaxerr.mli
SRCS += ./parsing/syntaxerr.ml
SRCS += ./parsing/ast_helper.mli
SRCS += ./parsing/ast_helper.ml
SRCS += ./parsing/ast_mapper.mli
SRCS += ./parsing/ast_mapper.ml
SRCS += ./parsing/builtin_attributes.mli
SRCS += ./parsing/builtin_attributes.ml
SRCS += ./parsing/parser.mli
SRCS += ./parsing/parser.ml
SRCS += ./parsing/lexer.mli
SRCS += ./parsing/lexer.ml
SRCS += ./parsing/ast_iterator.mli
SRCS += ./parsing/ast_iterator.ml
SRCS += ./parsing/parse.mli
SRCS += ./parsing/parse.ml
SRCS += ./parsing/printast.mli
SRCS += ./parsing/printast.ml

SRCS += ./typing/ident.mli
SRCS += ./typing/ident.ml
SRCS += ./typing/path.mli
SRCS += ./typing/path.ml
SRCS += ./typing/outcometree.mli
SRCS += ./typing/primitive.mli
SRCS += ./typing/primitive.ml
SRCS += ./typing/types.mli
SRCS += ./typing/types.ml
SRCS += ./typing/cmi_format.mli
SRCS += ./typing/cmi_format.ml
SRCS += ./typing/btype.mli
SRCS += ./typing/btype.ml
SRCS += ./typing/subst.mli
SRCS += ./typing/subst.ml
SRCS += ./typing/datarepr.mli
SRCS += ./typing/datarepr.ml
SRCS += ./typing/predef.mli
SRCS += ./typing/predef.ml
SRCS += ./typing/env.mli
SRCS += ./typing/env.ml
SRCS += ./typing/typedtree.mli
SRCS += ./typing/typedtree.ml
SRCS += ./typing/ctype.mli
SRCS += ./typing/ctype.ml
SRCS += ./typing/includecore.mli
SRCS += ./typing/includecore.ml
SRCS += ./typing/tast_mapper.mli
SRCS += ./typing/tast_mapper.ml
SRCS += ./typing/cmt_format.mli
SRCS += ./typing/cmt_format.ml
SRCS += ./typing/oprint.mli
SRCS += ./typing/oprint.ml
SRCS += ./typing/printtyp.mli
SRCS += ./typing/printtyp.ml
SRCS += ./typing/includeclass.mli
SRCS += ./typing/includeclass.ml
SRCS += ./typing/mtype.mli
SRCS += ./typing/mtype.ml
SRCS += ./typing/includemod.mli
SRCS += ./typing/includemod.ml
SRCS += ./typing/typetexp.mli
SRCS += ./typing/typetexp.ml
SRCS += ./typing/typedecl.mli
SRCS += ./typing/typedecl.ml

SRCS += ./bytecomp/lambda.mli
SRCS += ./bytecomp/lambda.ml
SRCS += ./typing/typeopt.mli
SRCS += ./typing/typeopt.ml

SRCS += ./bytecomp/cmo_format.mli
SRCS += ./bytecomp/runtimedef.mli
SRCS += ./bytecomp/runtimedef.ml
SRCS += ./bytecomp/instruct.mli
SRCS += ./bytecomp/instruct.ml
SRCS += ./bytecomp/meta.mli
SRCS += ./bytecomp/meta.ml
SRCS += ./bytecomp/bytesections.mli
SRCS += ./bytecomp/bytesections.ml
SRCS += ./bytecomp/symtable.mli
SRCS += ./bytecomp/symtable.ml

SRCS += ./typing/annot.mli
SRCS += ./typing/stypes.mli
SRCS += ./typing/stypes.ml
SRCS += ./typing/untypeast.mli
SRCS += ./typing/untypeast.ml
SRCS += ./typing/printpat.mli
SRCS += ./typing/printpat.ml
SRCS += ./typing/typedtreeIter.mli
SRCS += ./typing/typedtreeIter.ml
SRCS += ./typing/parmatch.mli
SRCS += ./typing/parmatch.ml
SRCS += ./typing/typecore.mli
SRCS += ./typing/typecore.ml
SRCS += ./typing/typeclass.mli
SRCS += ./typing/typeclass.ml
SRCS += ./typing/typemod.mli
SRCS += ./typing/typemod.ml
SRCS += ./typing/printtyped.mli
SRCS += ./typing/printtyped.ml

SRCS += ./bytecomp/printlambda.mli
SRCS += ./bytecomp/printlambda.ml
SRCS += ./bytecomp/switch.mli
SRCS += ./bytecomp/switch.ml
SRCS += ./bytecomp/matching.mli
SRCS += ./bytecomp/matching.ml
SRCS += ./bytecomp/translprim.mli
SRCS += ./bytecomp/translprim.ml
SRCS += ./bytecomp/translattribute.mli
SRCS += ./bytecomp/translattribute.ml
SRCS += ./bytecomp/translobj.mli
SRCS += ./bytecomp/translobj.ml
SRCS += ./bytecomp/translcore.mli
SRCS += ./bytecomp/translcore.ml
SRCS += ./bytecomp/translclass.mli
SRCS += ./bytecomp/translclass.ml
SRCS += ./bytecomp/translmod.mli
SRCS += ./bytecomp/translmod.ml
SRCS += ./bytecomp/simplif.mli
SRCS += ./bytecomp/simplif.ml
SRCS += ./bytecomp/bytegen.mli
SRCS += ./bytecomp/bytegen.ml
SRCS += ./bytecomp/printinstr.mli
SRCS += ./bytecomp/printinstr.ml
SRCS += ./bytecomp/opcodes.ml
SRCS += ./bytecomp/emitcode.mli
SRCS += ./bytecomp/emitcode.ml

SRCS += ./utils/ccomp.mli
SRCS += ./utils/ccomp.ml
SRCS += ./parsing/ast_invariants.mli
SRCS += ./parsing/ast_invariants.ml
SRCS += ./driver/pparse.mli
SRCS += ./driver/pparse.ml
SRCS += ./parsing/pprintast.mli
SRCS += ./parsing/pprintast.ml
SRCS += ./stdlib/scanf.mli
SRCS += ./stdlib/scanf.ml
SRCS += ./driver/compenv.mli
SRCS += ./driver/compenv.ml
SRCS += ./driver/compmisc.mli
SRCS += ./driver/compmisc.ml

SRCS += ./toplevel/genprintval.mli
SRCS += ./toplevel/genprintval.ml
SRCS += ./toplevel/toploop.mli
SRCS += ./toplevel/toploop.ml

SRCS += interpreter.ml

MLS = $(filter %.ml,$(SRCS))
CMOS = $(patsubst %.ml,%.cmo, $(MLS))

OCAMLOPT = ocamlopt.opt

.PHONY: all
all: $(TARGETS)
	cp -vf $(PROG).hex $(PROG).nwa

interpreter.d: $(SRCS)
	ocamldep $(INCLUDES) $^ > $@

%.cmi: %.mli
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

%.cmo: %.ml
	$(BIN)/omicrob $(OMICROB_PARAMS) -c $<

include interpreter.d

$(TARGETS): $(CMOS)
	@echo "omicrob to generate $@"
	$(BIN)/omicrob $(OMICROB_PARAMS) -gc $(GC_ALGO) -stack-size $(STACK_SIZE) -heap-size $(HEAP_SIZE) -cxxopt=-DEADK_APP_NAME=$(EADK_APP_NAME) $^ -o $@

echo:
	@echo $(MLS)

.PHONY: clean
clean:
	rm -rf ./*.cmi ./*.cmo ./*.cmx ./*.byte ./*.c ./*.arm_o ./*.elf ./*.arm_elf ./*.hex ./*.nwa ./*.elf ./*.bytecode ./*.o ./*.exe
	rm -rf **/*.cmi **/*.cmo

NWLINK = npx --yes -- nwlink@0.0.17

.PHONY: run
run: $(TARGETS)
	@echo "INSTALL $<"
	$(Q) $(NWLINK) install-nwa $<
