exception Fatal_error
val fatal_error : 'a -> 'b
val create_hashtable : int -> ('a * 'b) list -> ('a, 'b) Hashtbl.t
val may : ('a -> unit) -> 'a option -> unit
type ref_and_value = R : 'a ref * 'a -> ref_and_value
val protect_refs : ref_and_value list -> (unit -> 'a) -> 'a
