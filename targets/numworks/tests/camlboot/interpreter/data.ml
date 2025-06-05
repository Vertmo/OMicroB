open Asttypes
open Parsetree

module SMap = Map.Make (String)
module SSet = Set.Make (String)

type module_unit_id = Path of string
module UStore = Map.Make(struct
  type t = module_unit_id
  let compare (Path a) (Path b) = String.compare a b
end)

module Ptr : sig
  type 'a t
  val create : 'a -> 'a t

  exception Null
  val get : 'a t -> 'a

  val dummy : unit -> 'a t

  exception Full
  val backpatch : 'a t -> 'a -> unit
end = struct
  type 'a t = 'a option ref

  let create v = ref (Some v)

  exception Null
  let get ptr = match !ptr with
    | None -> raise Null
    | Some v -> v

  let dummy () = ref None

  exception Full
  let backpatch ptr v = match !ptr with
      | Some _ -> raise Full
      | None -> ptr := Some v
end

let ptr v = Ptr.create v
let onptr f = fun v -> f (Ptr.get v)

type value = value_ Ptr.t
and value_ =
  | Int of int
  | Int32 of int32
  | Int64 of int64
  | Fun of arg_label * expression option * pattern * expression * env
  | Function of case list * env
  | String of bytes
  | Float of float
  | Tuple of value list
  | Constructor of string * int * value option
  | Poly_variant of string * value option
  | Prim of (value -> value)
  | Fexpr of fexpr
  | ModVal of mdl
  | InChannel of in_channel
  | OutChannel of out_channel
  | Record of value ref SMap.t
  | Lz of (unit -> value) ref
  | Array of value array
  | Fun_with_extra_args of value * value list * (arg_label * value) SMap.t
  | Object of object_value

and fexpr = Location.t -> (arg_label * expression) list -> expression option

and 'a env_map = (bool * 'a) SMap.t
(* the boolean tracks whether the value should be exported in the
   output environment *)

and env = {
  values : value_or_lvar env_map;
  modules : mdl env_map;
  constructors : int env_map;
  variant_types : string list env_map;
  classes : class_def env_map;
  current_object : object_value option;
}

and value_or_lvar =
  | Value of value
  | Instance_variable of object_value * string

and class_def = class_expr * env ref

and mdl =
  | Unit of module_unit_id * module_unit_state ref
  | Module of mdl_val
  | Functor of string * module_expr * env

and mdl_val = {
    mod_values : value SMap.t;
    mod_modules : mdl SMap.t;
    mod_constructors : int SMap.t;
    mod_variant_types : string list SMap.t;
    mod_classes : class_def SMap.t;
  }

and module_unit_state =
  | Not_initialized_yet
  | Initialized of mdl_val
(* OCaml calls a "compilation unit" the language object corresponding
   to a group of files of the same name with different extensions
   (foo.ml, foo.mli in source form, foo.cm* in compiled form). From
   the language those are also visible implicitly as modules (Foo),
   but they are not exactly identical to modules as well -- in what
   sort of dependencies are allowed between units, in particular.

   Instead of "compilation units" which sounds strange in an
   interpreter, we just call these "module units" or "units".

   In our value representation, some of the modules in the environment
   may in fact be units (a unit is a category of module), and
   initialized units contain module data, like a normal module.

   The -no-alias-deps flag allows an OCaml source fragment to create
   an alias to a unit that has not been evaluated yet -- allowing
   cyclic dependencies where each cycle contains a "weak" edge that is
   just a module-alias occurrence

   From an operational point of view, this corresponds to allowing
   implicit recursive definition of units, where all units can
   alias/reference each other (even units evaluated later), but a unit
   may only dereference (access the module data of) a unit evaluated
   earlier.

   To support these recursive definitions, we give backpatching
   semantics to unit definitions: all the units that are to be
   evaluated are loaded at once in the environment as (references to)
   "non initialized" units, and after each unit is evaluated to some
   module data we mutate its state in the environment, which makes
   non-aliasing uses possible for further units.
*)

and object_value = {
  env: env;
  self: pattern;
  initializers: expr_in_object list;
  named_parents: object_value SMap.t;
  variables: value ref SMap.t;
  methods: expr_in_object SMap.t;

  parent_view: string list;
  (* When evaluating a call super#foo, it would be wrong to just
     resolve the call in a parent object bound to the 'super'
     identifier in the current environment. Indeed, when then
     executing the code of super#foo, self-calls of the form self#bar
     would be resolved in the parent object 'super', instead of in the
     current object 'self', which is the intended late-binding
     semantics.

     To solve this issue, we bind 'super' not to the parent object,
     but to the *current* object "viewed as its parent 'super'"; the
     'parent_view' field stores that view (in general there may be
     several levels of super-calls nesting, so it's a list). The view
     affects how methods are resolved -- their code is looked up
     in the right parent object.
   *)
}
and source_object =
  | Current_object
  | Parent of object_value
and expr_in_object = {
  source : source_object;

  instance_variable_scope : SSet.t;
  (** The scoping of instance variables within object declarations
      makes them in the scope of only some of the expressions in methods
      and initializers; an "instance variable scope" remembers the set
      of instance variables that are in scope of a given expression). *)

  named_parents_scope : SSet.t;
  (** Similarly, it may be that only some of the 'inherit foo as x' fields
      scope over the current piece of code, so we keep a set of visible parents.

      Remark: the self-pattern is always at the beginning of a class
      or object declaration, so it is in the scope of all
      expressions. *)

  expr : expression;
}

exception InternalException of value

let unit = ptr @@ Constructor ("()", 0, None)

let is_true = onptr @@ function
  | Constructor ("true", _, None) -> true
  | Constructor ("false", _, None) -> false
  | _ -> assert false

let rec pp_print_value ff =
  failwith "TODO pp_print_value"
 (* onptr @@ function *)
  (* | Int n -> Format.fprintf ff "%d" n *)
  (* | Int32 n -> Format.fprintf ff "%ldl" n *)
  (* | Int64 n -> Format.fprintf ff "%LdL" n *)
  (* | Nativeint n -> Format.fprintf ff "%ndn" n *)
  (* | Fexpr _ -> Format.fprintf ff "<fexpr>" *)
  (* | Fun _ | Function _ | Prim _ | Lz _ | Fun_with_extra_args _ -> *)
  (*   Format.fprintf ff "<function>" *)
  (* | String s -> Format.fprintf ff "%S" (Bytes.to_string s) *)
  (* | Float f -> Format.fprintf ff "%f" f *)
  (* | Tuple l -> *)
  (*   Format.fprintf *)
  (*     ff *)
  (*     "(%a)" *)
  (*     (Format.pp_print_list *)
  (*        ~pp_sep:(fun ff () -> Format.fprintf ff ", ") *)
  (*        pp_print_value) *)
  (*     l *)
  (* | Constructor (c, d, arg) -> *)
  (*   Format.fprintf ff "%s#%d%a" c d pp_print_arg arg *)
  (* | Poly_variant (c, arg) -> *)
  (*   Format.fprintf ff "`%s%a" c pp_print_arg arg *)
  (* | ModVal _ -> Format.fprintf ff "<module>" *)
  (* | InChannel _ -> Format.fprintf ff "<in_channel>" *)
  (* | OutChannel _ -> Format.fprintf ff "<out_channel>" *)
  (* | Record r -> *)
  (*   Format.fprintf ff "{"; *)
  (*   SMap.iter (fun k v -> Format.fprintf ff "%s = %a; " k pp_print_value !v) r; *)
  (*   Format.fprintf ff "}" *)
  (* | Array a -> *)
  (*   Format.fprintf *)
  (*     ff *)
  (*     "[|%a|]" *)
  (*     (Format.pp_print_list *)
  (*        ~pp_sep:(fun ff () -> Format.fprintf ff "; ") *)
  (*        pp_print_value) *)
  (*     (Array.to_list a) *)
  (* | Object _ -> Format.fprintf ff "<object>" *)

and pp_print_arg ff = function
  | None -> ()
  | Some v -> print_string " "; pp_print_value ff v

let rec string_of_value (arg : value) : string =
  match (Ptr.get arg) with
  | Int n -> string_of_int n
  | Int32 n -> Int32.to_string n ^ "l" (* Standard way to represent int32 literals *)
  | Int64 n -> Int64.to_string n ^ "L" (* Standard way to represent int64 literals *)
  (* | Nativeint n -> Nativeint.to_string n ^ "n" (* Standard way to represent nativeint literals *) *)
  | Fexpr _ -> "<fexpr>"
  | Fun _ | Function _ | Prim _ | Lz _ | Fun_with_extra_args _ ->
    "<function>"
  | String s -> "\"" ^ (Bytes.to_string (Bytes.escaped s)) ^ "\""
  | Float f -> string_of_float f
  | Tuple l ->
    "(" ^ (String.concat ", " (List.map string_of_value l)) ^ ")"
  | Constructor (c, d, arg) ->
    c ^ "#" ^ (string_of_int d) ^ (string_of_arg arg)
  | Poly_variant (c, arg) ->
    "`" ^ c ^ (string_of_arg arg)
  | ModVal _ -> "<module>"
  | InChannel _ -> "<in_channel>"
  | OutChannel _ -> "<out_channel>"
  | Record r ->
    let fields =
      SMap.fold (fun k v acc ->
        (k ^ " = " ^ (string_of_value !v)) :: acc
      ) r []
    in
    "{ " ^ (String.concat "; " (List.rev fields)) ^ " }" (* List.rev to maintain insertion order if any *)
  | Array a ->
    "[|" ^ (String.concat "; " (List.map string_of_value (Array.to_list a))) ^ "|]"
  | Object _ -> "<object>"

and string_of_arg (arg : value option) : string =
  match arg with
  | None -> ""
  | Some v -> " " ^ (string_of_value v)

let print_value_to_stdout (v : value) : unit =
  print_string (string_of_value v);
  print_newline ()

let pp_print_unit_id ppf (Path s) =
  failwith "TODO pp_print_unit_id"
  (* Format.fprintf ppf "%S" s *)

let read_caml_int s =
  let c = ref 0L in
  let sign, init =
    if String.length s > 0 && s.[0] = '-' then (Int64.of_int (-1), 1) else (1L, 0)
  in
  let base, init =
    if String.length s >= init + 2 && s.[init] = '0'
    then
      ( (match s.[init + 1] with
        | 'x' | 'X' -> 16L
        | 'b' | 'B' -> 2L
        | 'o' | 'O' -> 8L
        | _ -> assert false),
        init + 2 )
    else (10L, init)
  in
  for i = init to String.length s - 1 do
    match s.[i] with
    | x when '0' <= x && x <= '9' ->
      c := Int64.(add (mul base !c) (of_int (int_of_char x - int_of_char '0')))
    | x when 'a' <= x && x <= 'f' ->
      c :=
        Int64.(
          add (mul base !c) (of_int (int_of_char x - int_of_char 'a' + 10)))
    | x when 'A' <= x && x <= 'F' ->
      c :=
        Int64.(
          add (mul base !c) (of_int (int_of_char x - int_of_char 'A' + 10)))
    | '_' -> ()
    | _ ->
      (* Format.eprintf "FIXME literal: %s@." s; *)
      assert false
  done;
  Int64.mul sign !c


(* XXX Manual implementation of x ** (float_of_int n). *)
let rec power_float_of_int x n =
  if n = 0 then 1.0
  else if n < 0 then 1.0 /. power_float_of_int x (-n)
  else
    let rec aux acc x n =
      if n = 0 then acc
      else if n mod 2 = 1 then aux (acc *. x) (x *. x) (n / 2)
      else aux acc (x *. x) (n / 2)
    in
    aux 1.0 x n


(* XXX Manual implementation of float_of_string, helped by Google's AI Gemini and tested manually. *)
let float_of_string (s : string) : float =
  let len = String.length s in
  if len = 0 then invalid_arg "float_of_string: empty string";

  let i = ref 0 in

  (* Skip leading whitespace *)
  while !i < len && (s.[!i] = ' ' || s.[!i] = '\t' || s.[!i] = '\n' || s.[!i] = '\r') do
    incr i
  done;

  (* Handle sign *)
  let sign =
    if !i < len && s.[!i] = '-' then (incr i; -1.0)
    else if !i < len && s.[!i] = '+' then (incr i; 1.0)
    else 1.0
  in

  (* Check for special values: NaN, Inf, Infinity *)
  let parse_special () =
    let remaining_len = len - !i in
    if remaining_len >= 3 then
      let sub_lower = String.lowercase_ascii (String.sub s !i remaining_len) in
      if sub_lower = "nan" then (
        i := len; (* Consume the rest of the string *)
        Some nan
      ) else if remaining_len >= 3 && sub_lower = "inf" then (
        i := len; (* Consume the rest of the string *)
        Some (sign *. infinity)
      ) else if remaining_len >= 8 && sub_lower = "infinity" then (
        i := len; (* Consume the rest of the string *)
        Some (sign *. infinity)
      ) else
        None (* Not a special value *)
    else
      None
  in

  match parse_special () with
  | Some special_val -> special_val
  | None ->
    let current_val = ref 0.0 in
    let decimal_found = ref false in
    let decimal_place = ref 0.1 in (* For fractional part *)
    let digits_read = ref 0 in
    let parsing_digits = ref true in

    (* Parse integer and fractional part *)
    while !i < len && !parsing_digits do
      let c = s.[!i] in
      if c >= '0' && c <= '9' then (
        digits_read := !digits_read + 1;
        if not !decimal_found then
          current_val := !current_val *. 10.0 +. (float_of_int (Char.code c - Char.code '0'))
        else (
          current_val := !current_val +. (float_of_int (Char.code c - Char.code '0')) *. !decimal_place;
          decimal_place := !decimal_place *. 0.1;
        );
        incr i
      ) else if c = '.' && not !decimal_found then (
        decimal_found := true;
        incr i
      ) else
        parsing_digits := false (* Stop parsing digits *)
    done;

    if !digits_read = 0 then invalid_arg "float_of_string: no digits found";

    (* Handle exponent part *)
    let exponent_val = ref 0 in
    let exponent_sign = ref 1 in
    let parsing_exponent = ref true in

    if !i < len && (s.[!i] = 'e' || s.[!i] = 'E') then (
      incr i; (* Consume 'e' or 'E' *)
      if !i < len && s.[!i] = '-' then (exponent_sign := -1; incr i)
      else if !i < len && s.[!i] = '+' then (incr i);

      let exponent_digits_read = ref 0 in
      while !i < len && !parsing_exponent do
        let c = s.[!i] in
        if c >= '0' && c <= '9' then (
          exponent_digits_read := !exponent_digits_read + 1;
          exponent_val := !exponent_val * 10 + (Char.code c - Char.code '0');
          incr i
        ) else
          parsing_exponent := false (* Stop parsing exponent digits *)
      done;
      if !exponent_digits_read = 0 then
        invalid_arg "float_of_string: exponent has no digits"
    );

    (* Apply exponent *)
    (* let final_val = !current_val *. (10.0 ** (float_of_int (!exponent_val * !exponent_sign))) in *)
    let final_val = !current_val *. (power_float_of_int 10.0 (!exponent_val * !exponent_sign)) in
    let result = sign *. final_val in

    (* Skip trailing whitespace *)
    while !i < len && (s.[!i] = ' ' || s.[!i] = '\t' || s.[!i] = '\n' || s.[!i] = '\r') do
      incr i
    done;

    if !i <> len then invalid_arg "float_of_string: extraneous characters";

    result

let value_of_constant const = ptr @@ match const with
  | Pconst_integer (s, None) -> Int (Int64.to_int (read_caml_int s))
  | Pconst_integer (s, Some 'l') -> Int32 (Int64.to_int32 (read_caml_int s))
  | Pconst_integer (s, Some 'L') -> Int64 (read_caml_int s)
  | Pconst_integer (_s, Some c) ->
    (* Format.eprintf "Unsupported suffix %c@." c; *)
    assert false
  | Pconst_char c -> Int (int_of_char c)
  | Pconst_float (f, _) -> Float (float_of_string f)
  | Pconst_string (s, _) -> String (Bytes.of_string s)

let rec value_compare v1 v2 = match Ptr.get v1, Ptr.get v2 with
  | Fun _, _
  | Function _, _
  | _, Fun _
  | _, Function _
  | Lz _, _
  | _, Lz _
  | Fun_with_extra_args _, _
  | _, Fun_with_extra_args _ ->
    failwith "tried to compare function"
  | ModVal _, _ | _, ModVal _ -> failwith "tried to compare module"
  | InChannel _, _ | OutChannel _, _ | _, InChannel _ | _, OutChannel _ ->
    failwith "tried to compare channel"
  | Fexpr _, _ | _, Fexpr _ -> failwith "tried to compare fexpr"
  | Prim _, _ | _, Prim _ -> failwith "tried to compare prim"
  | Object _, _ | _, Object _ -> failwith "tried to compare object"

  | Int n1, Int n2 -> compare n1 n2
  | Int _, _ -> assert false

  | Int32 n1, Int32 n2 -> compare n1 n2
  | Int32 _, _ -> assert false

  | Int64 n1, Int64 n2 -> compare n1 n2
  | Int64 _, _ -> assert false


  | Float f1, Float f2 -> compare f1 f2
  | Float _, _ -> assert false

  | String s1, String s2 -> compare s1 s2
  | String _, _ -> assert false

  | Constructor (c1, d1, arg1), Constructor (c2, d2, arg2) ->
    let c = compare (d1, c1) (d2, c2) in
    if c <> 0 then c else
    value_compare_arg arg1 arg2
  | Constructor _, _ -> assert false

  | Poly_variant (c1, arg1), Poly_variant (c2, arg2) ->
    let c = compare c1 c2 in
    if c <> 0 then c else
    value_compare_arg arg1 arg2
  | Poly_variant _, _ -> assert false

  | Tuple l1, Tuple l2 ->
    assert (List.length l1 = List.length l2);
    List.fold_left2
      (fun cur x y -> if cur = 0 then value_compare x y else cur)
      0
      l1
      l2
  | Tuple _, _ -> assert false

  | Record r1, Record r2 ->
    let map1 =
      SMap.merge
        (fun _ u v ->
          match (u, v) with
          | None, None -> None
          | None, Some _ | Some _, None -> assert false
          | Some u, Some v -> Some (!u, !v))
        r1
        r2
    in
    SMap.fold
      (fun _ (u, v) cur -> if cur = 0 then value_compare u v else cur)
      map1
      0
  | Record _, _ -> assert false

  | Array a1, Array a2 ->
    let comp_len = compare (Array.length a1) (Array.length a2) in
    if comp_len <> 0 then comp_len
    else (
      let cmp = ref 0 in
      let count = ref 0 in
      while !cmp = 0 && !count < Array.length a1 do
        cmp := value_compare a1.(!count) a2.(!count);
        incr count
      done;
      !cmp
    )
  | Array _, _ -> assert false

and value_compare_arg arg1 arg2 =
  match arg1, arg2 with
  | None, None -> 0
  | None, Some _ -> -1
  | Some _, None -> 1
  | Some v1, Some v2 -> value_compare v1 v2

let value_equal v1 v2 = value_compare v1 v2 = 0

let value_lt v1 v2 = value_compare v1 v2 < 0
let value_le v1 v2 = value_compare v1 v2 <= 0
let value_gt v1 v2 = value_compare v1 v2 > 0
let value_ge v1 v2 = value_compare v1 v2 >= 0

let next_exn_id =
  let last_exn_id = ref (-1) in
  fun () ->
    incr last_exn_id;
    !last_exn_id

exception No_module_data
let get_module_data loc = function
  | Module data -> data
  | Functor _ ->
     (* Format.eprintf "%a@.Tried to access the components of a functor@." *)
     (*   Location.print_loc loc; *)
     raise No_module_data
  | Unit (unit_id, unit_state) ->
     begin match !unit_state with
       | Initialized data -> data
       | exception Not_found ->
          (* Format.eprintf "%a@.Tried to access the undeclared unit %a@." *)
          (*  Location.print_loc loc *)
          (*  pp_print_unit_id unit_id; *)
          raise No_module_data
       | Not_initialized_yet ->
          (* Format.eprintf "%a@.unit %a is not yet initialized@." *)
          (*   Location.print_loc loc *)
          (*   pp_print_unit_id unit_id; *)
          raise No_module_data
     end

let module_name_of_unit_path path =
  if path = "ocaml.py" then
    "Ocaml"
  else begin

    (* print_string "path = ";
    print_endline path; *)

    (* This function is used to convert a unit path (e.g. "foo/bar/baz.ml") *)
    (* into a module name (e.g. "Foo_bar_baz"). It is used to create the *)
    (* module name for the unit when it is loaded into the environment. *)
    (* The module name is derived from the path by capitalizing each part *)
    (* of the path and joining them with underscores. *)
    (* The path is expected to be a valid unit path, i.e. it should not contain *)
    (* any invalid characters or be empty. *)
    (* The function currently raises an exception, as it is not yet implemented. *)
    (* failwith "TODO module_name_of_unit_path" *)
    let n = String.length path in
    let guessed_ml_extension = String.sub path (n - 3) 3 in
    let path_without_extension =
      if guessed_ml_extension = ".ml" then
        String.sub path 3 (n - 6)
      else
        String.sub path 3 (n - 3)
    in

    (* print_string "=> path_without_extension = ";
    print_endline path_without_extension; *)

    (* We remove the ".ml" extension from the path, as it is not needed for the module name. *)
    (* The module name is derived from the path by capitalizing each part and joining them with underscores. *)
    (* The path is expected to be a valid unit path, i.e. it should not contain any invalid characters or be empty. *)
    (* The function currently raises an exception, as it is not yet implemented. *)
    (* failwith "TODO module_name_of_unit_path" *)
    let module_name = String.split_on_char '/' path_without_extension
      |> List.map String.capitalize_ascii
      |> String.concat "_"
      |> String.capitalize_ascii
      |> String.map (function ' ' -> '_' | c -> c)
      |> String.trim
    in

    (* print_string "==> module_name = ";
    print_endline module_name; *)

    module_name
  end
  (* XXX: this was the previous implementation, but the Filename module is not available, so we hack it away (see above). *)
  (* path *)
  (* |> Filename.basename *)
  (* |> Filename.remove_extension *)
  (* |> String.capitalize_ascii *)
