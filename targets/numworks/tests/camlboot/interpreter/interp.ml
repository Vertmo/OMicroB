open Data
open Conf
open Eval
open Envir

let stdlib = {|external raise : exn -> 'a = "%raise"

(* Composition operators *)

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"
external ( @@ ) : ('a -> 'b) -> 'a -> 'b = "%apply"

(* Comparisons *)

external ( = ) : 'a -> 'a -> bool = "%equal"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( > ) : 'a -> 'a -> bool = "%greaterthan"
external ( <= ) : 'a -> 'a -> bool = "%lessequal"
external ( >= ) : 'a -> 'a -> bool = "%greaterequal"
external compare : 'a -> 'a -> int = "%compare"

let min x y = if x <= y then x else y
let max x y = if x >= y then x else y

external ( == ) : 'a -> 'a -> bool = "%eq"
external ( != ) : 'a -> 'a -> bool = "%noteq"

(* Boolean operations *)

external not : bool -> bool = "%boolnot"
external ( & ) : bool -> bool -> bool = "%sequand"
external ( && ) : bool -> bool -> bool = "%sequand"
external ( or ) : bool -> bool -> bool = "%sequor"
external ( || ) : bool -> bool -> bool = "%sequor"

(* Integer operations *)

external ( ~- ) : int -> int = "%negint"
external ( ~+ ) : int -> int = "%identity"
external succ : int -> int = "%succint"
external pred : int -> int = "%predint"
external ( + ) : int -> int -> int = "%addint"
external ( - ) : int -> int -> int = "%subint"
external ( * ) : int -> int -> int = "%mulint"
external ( / ) : int -> int -> int = "%divint"
external ( mod ) : int -> int -> int = "%modint"

let abs x = if x >= 0 then x else -x

external ( land ) : int -> int -> int = "%andint"
external ( lor ) : int -> int -> int = "%orint"
external ( lxor ) : int -> int -> int = "%xorint"

let lnot x = x lxor (-1)

external ( lsl ) : int -> int -> int = "%lslint"
external ( lsr ) : int -> int -> int = "%lsrint"
external ( asr ) : int -> int -> int = "%asrint"

let max_int = (-1) lsr 1
let min_int = max_int + 1

(* Floating-point operations *)

external ( ~-. ) : float -> float = "%negfloat"
external ( ~+. ) : float -> float = "%identity"
external ( +. ) : float -> float -> float = "%addfloat"
external ( -. ) : float -> float -> float = "%subfloat"
external ( *. ) : float -> float -> float = "%mulfloat"
external ( /. ) : float -> float -> float = "%divfloat"
external ( ** ) : float -> float -> float = "caml_power_float" "pow"
  [@@unboxed] [@@noalloc]
external exp : float -> float = "caml_exp_float" "exp" [@@unboxed] [@@noalloc]
external expm1 : float -> float = "caml_expm1_float" "caml_expm1"
  [@@unboxed] [@@noalloc]
external acos : float -> float = "caml_acos_float" "acos"
  [@@unboxed] [@@noalloc]
external asin : float -> float = "caml_asin_float" "asin"
  [@@unboxed] [@@noalloc]
external atan : float -> float = "caml_atan_float" "atan"
  [@@unboxed] [@@noalloc]
external atan2 : float -> float -> float = "caml_atan2_float" "atan2"
  [@@unboxed] [@@noalloc]
external hypot : float -> float -> float
               = "caml_hypot_float" "caml_hypot" [@@unboxed] [@@noalloc]
external cos : float -> float = "caml_cos_float" "cos" [@@unboxed] [@@noalloc]
external cosh : float -> float = "caml_cosh_float" "cosh"
  [@@unboxed] [@@noalloc]
external log : float -> float = "caml_log_float" "log" [@@unboxed] [@@noalloc]
external log10 : float -> float = "caml_log10_float" "log10"
  [@@unboxed] [@@noalloc]
external log1p : float -> float = "caml_log1p_float" "caml_log1p"
  [@@unboxed] [@@noalloc]
external sin : float -> float = "caml_sin_float" "sin" [@@unboxed] [@@noalloc]
external sinh : float -> float = "caml_sinh_float" "sinh"
  [@@unboxed] [@@noalloc]
external sqrt : float -> float = "caml_sqrt_float" "sqrt"
  [@@unboxed] [@@noalloc]
external tan : float -> float = "caml_tan_float" "tan" [@@unboxed] [@@noalloc]
external tanh : float -> float = "caml_tanh_float" "tanh"
  [@@unboxed] [@@noalloc]
external ceil : float -> float = "caml_ceil_float" "ceil"
  [@@unboxed] [@@noalloc]
external floor : float -> float = "caml_floor_float" "floor"
  [@@unboxed] [@@noalloc]
external abs_float : float -> float = "%absfloat"
external copysign : float -> float -> float
                  = "caml_copysign_float" "caml_copysign"
                  [@@unboxed] [@@noalloc]
external mod_float : float -> float -> float = "caml_fmod_float" "fmod"
  [@@unboxed] [@@noalloc]
external frexp : float -> float * int = "caml_frexp_float"
external ldexp : (float [@unboxed]) -> (int [@untagged]) -> (float [@unboxed]) =
  "caml_ldexp_float" "caml_ldexp_float_unboxed" [@@noalloc]
external modf : float -> float * float = "caml_modf_float"
external float : int -> float = "%floatofint"
external float_of_int : int -> float = "%floatofint"
external truncate : float -> int = "%intoffloat"
external int_of_float : float -> int = "%intoffloat"

let max_float = 1.79769313486231571e+308

let min_float = 2.22507385850720138e-308

let epsilon_float = 2.22044604925031308e-16
|}

let parse filename =
  if filename = "stdlib.py" then
    let lexbuf = Lexing.from_string stdlib in
    Location.init lexbuf filename;
    let parsed = Parse.implementation lexbuf in
    parsed
  else
    let inc =
      try
        open_in filename
      with e ->
        begin
        (* Printf.eprintf "Error opening file: %s@." filename; *)
        print_string "Error opening file: ";
        print_string filename;
        raise e
        end
    in
    let lexbuf = Lexing.from_channel inc in
    Location.init lexbuf filename;
    (*  let parsed = Parser.implementation Lexer.real_token lexbuf in *)
    let parsed = Parse.implementation lexbuf in
    close_in inc;
    parsed

(** Previous content of the interp.ml file *)
type env_flag = Open of Longident.t

let stdlib_flag = [Open (Longident.Lident "Stdlib")]
let no_stdlib_flag = []

let stdlib_units =
  (* let stdlib_path = stdlib_path () in *)
  [(no_stdlib_flag, "stdlib.py")]

let eval_env_flag ~loc env flag =
  match flag with
  | Open module_ident ->
     let module_ident = Location.mkloc module_ident loc in
     env_extend false env (env_get_module_data env module_ident)

let debug = true
(* let debug = false *)

let load_rec_units env flags_and_units =
  let unit_paths = List.map snd flags_and_units in
  let env = List.fold_left declare_unit env unit_paths in
  List.fold_left
    (fun global_env (flags, unit_path) ->
      let module_name = module_name_of_unit_path unit_path in
      if debug then begin
        (* Printf.eprintf "Loading %s from %s (or %s.py) @." module_name unit_path unit_path; *)
        print_endline ("Loading " ^ module_name ^ " from " ^ unit_path);
      end;
      let module_contents =
        let loc = Location.in_file unit_path in
        let local_env = List.fold_left (eval_env_flag ~loc) global_env flags in
        eval_structure Primitives.prims local_env (parse unit_path)
      in
      define_unit global_env unit_path (make_module_data module_contents))
    env
    flags_and_units

let () = clear_screen ()

let stdlib_env =
  let env = Runtime_base.initial_env in
  let env = load_rec_units env stdlib_units in
  env

let default_filename = "ocaml.py"

let run_files () =
  let rev_files = ref [default_filename] in
  let anon_fun file = rev_files := file :: !rev_files in
  (* Arg.parse [] anon_fun ""; *)
  let files = List.rev !rev_files in
  files
  |> List.map (fun file -> stdlib_flag, file)
  |> load_rec_units stdlib_env
  |> ignore

let () =
  try
    run_files ()
  with
  | InternalException e ->
     print_endline ("Code raised internal exception: " ^ (string_of_value e) )
  | _ -> print_endline "Error"

let () =
  while true do () done
