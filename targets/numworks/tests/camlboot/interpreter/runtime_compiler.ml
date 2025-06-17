open Data
open Runtime_lib
open Runtime_base

let wrap_array_id a = ptr @@ Array a

let unwrap_array_id = onptr @@ function
  | Array a -> a
  | _ -> assert false

let unwrap_position = onptr @@ function
  | Record r ->
    Lexing.
      { pos_fname = unwrap_string !(SMap.find "pos_fname" r);
        pos_lnum = unwrap_int !(SMap.find "pos_lnum" r);
        pos_bol = unwrap_int !(SMap.find "pos_bol" r);
        pos_cnum = unwrap_int !(SMap.find "pos_cnum" r)
      }
  | _ -> assert false

let wrap_position Lexing.{ pos_fname; pos_lnum; pos_bol; pos_cnum } =
  ptr @@ Record
    (SMap.of_list
       [ ("pos_fname", ref (wrap_string pos_fname));
         ("pos_lnum", ref (wrap_int pos_lnum));
         ("pos_bol", ref (wrap_int pos_bol));
         ("pos_cnum", ref (wrap_int pos_cnum))
    ])

(* let wrap_gc_stat *)
(*     Gc. *)
(*       { minor_words; *)
(*         promoted_words; *)
(*         major_words; *)
(*         minor_collections; *)
(*         major_collections; *)
(*         heap_words; *)
(*         heap_chunks; *)
(*         live_words; *)
(*         live_blocks; *)
(*         free_words; *)
(*         free_blocks; *)
(*         largest_free; *)
(*         fragments; *)
(*         compactions; *)
(*         top_heap_words; *)
(*         stack_size *)
(*       } *)
(*   = *)
(*   ptr @@ Record *)
(*     (SMap.of_seq *)
(*     @@ List.to_seq *)
(*          [ ("minor_words", ref (wrap_float minor_words)); *)
(*            ("promoted_words", ref (wrap_float promoted_words)); *)
(*            ("major_words", ref (wrap_float major_words)); *)
(*            ("minor_collections", ref (wrap_int minor_collections)); *)
(*            ("major_collections", ref (wrap_int major_collections)); *)
(*            ("heap_words", ref (wrap_int heap_words)); *)
(*            ("heap_chunks", ref (wrap_int heap_chunks)); *)
(*            ("live_words", ref (wrap_int live_words)); *)
(*            ("live_blocks", ref (wrap_int live_blocks)); *)
(*            ("free_words", ref (wrap_int free_words)); *)
(*            ("free_blocks", ref (wrap_int free_blocks)); *)
(*            ("largest_free", ref (wrap_int largest_free)); *)
(*            ("fragments", ref (wrap_int fragments)); *)
(*            ("compactions", ref (wrap_int compactions)); *)
(*            ("top_heap_words", ref (wrap_int top_heap_words)); *)
(*            ("stack_size", ref (wrap_int stack_size)) *)
(*          ]) *)

(* TODO: Menhir-using OCaml versions do not have a global parser state
   anymore, so we should be able to clean this up -- all indirect
   references to the Parsing standard library module should go
   away. *)
type parser_env =
  { mutable s_stack : int array;
    (* States *)
    mutable v_stack : Obj.t array;
    (* Semantic attributes *)
    mutable symb_start_stack : Lexing.position array;
    (* Start positions *)
    mutable symb_end_stack : Lexing.position array;
    (* End positions *)
    mutable stacksize : int;
    (* Size of the stacks *)
    mutable stackbase : int;
    (* Base sp for current parse *)
    mutable curr_char : int;
    (* Last token read *)
    mutable lval : Obj.t;
    (* Its semantic attribute *)
    mutable symb_start : Lexing.position;
    (* Start pos. of the current symbol*)
    mutable symb_end : Lexing.position;
    (* End pos. of the current symbol *)
    mutable asp : int;
    (* The stack pointer for attributes *)
    mutable rule_len : int;
    (* Number of rhs items in the rule *)
    mutable rule_number : int;
    (* Rule number to reduce by *)
    mutable sp : int;
    (* Saved sp for parse_engine *)
    mutable state : int;
    (* Saved state for parse_engine *)
    mutable errflag : int
    }

let unwrap_parser_env = onptr @@ function
  | Record r ->
    { s_stack = unwrap_array unwrap_int !(SMap.find "s_stack" r);
      v_stack = Obj.magic (unwrap_array_id !(SMap.find "v_stack" r));
      symb_start_stack =
        unwrap_array unwrap_position !(SMap.find "symb_start_stack" r);
      symb_end_stack =
        unwrap_array unwrap_position !(SMap.find "symb_end_stack" r);
      stacksize = unwrap_int !(SMap.find "stacksize" r);
      stackbase = unwrap_int !(SMap.find "stackbase" r);
      curr_char = unwrap_int !(SMap.find "curr_char" r);
      lval = Obj.repr !(SMap.find "lval" r);
      symb_start = unwrap_position !(SMap.find "symb_start" r);
      symb_end = unwrap_position !(SMap.find "symb_end" r);
      asp = unwrap_int !(SMap.find "asp" r);
      rule_len = unwrap_int !(SMap.find "rule_len" r);
      rule_number = unwrap_int !(SMap.find "rule_number" r);
      sp = unwrap_int !(SMap.find "sp" r);
      state = unwrap_int !(SMap.find "state" r);
      errflag = unwrap_int !(SMap.find "errflag" r)
    }
  | _ -> assert false

let apply_ref =
  ref
    (fun _ _ -> assert false
      : value -> (Asttypes.arg_label * value) list -> value)

external lex_engine
  :  Lexing.lex_tables ->
  int ->
  Lexing.lexbuf ->
  int
  = "caml_lex_engine"

let unwrap_lexbuf v =
  match Ptr.get v with
  | _ -> assert false

let sync_lexbuf v lb =
  match Ptr.get v with
  | _ -> assert false

let unwrap_lex_tables = onptr @@ function
  | _ -> assert false

let lex_engine_wrapper tables n lexbuf =
  let nbuf = unwrap_lexbuf lexbuf in
  let tbls = unwrap_lex_tables tables in
  let res = lex_engine tbls n nbuf in
  sync_lexbuf lexbuf nbuf;
  res

let lex_engine_prim =
  prim3 lex_engine_wrapper wrap_exn id unwrap_int id wrap_int
