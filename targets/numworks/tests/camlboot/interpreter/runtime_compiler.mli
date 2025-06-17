open Data

val wrap_array_id : value array -> value
val unwrap_array_id : value -> value array
val unwrap_position : value -> Lexing.position
val wrap_position : Lexing.position -> value
val apply_ref :
  (value -> (Asttypes.arg_label * value) list -> value)
  ref
external lex_engine : Lexing.lex_tables -> int -> Lexing.lexbuf -> int
  = "caml_lex_engine"
val unwrap_lexbuf : value -> Lexing.lexbuf
val sync_lexbuf : value -> Lexing.lexbuf -> unit
val unwrap_lex_tables : value -> Lexing.lex_tables
val lex_engine_prim : value
