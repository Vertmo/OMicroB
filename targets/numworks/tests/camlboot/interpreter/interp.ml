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

let parse_string str =
  let lexbuf = Lexing.from_string str in
  Location.init lexbuf "";
  Parse.implementation lexbuf

let parse_file filename =
  if filename = "stdlib.py" then parse_string stdlib
  else
    let inc =
      try
        open_in filename
      with e -> (
          print_string "Error opening file: ";
          print_string filename;
          raise e
        )
    in
    let lexbuf = Lexing.from_channel inc in
    Location.init lexbuf filename;
    (*  let parsed = Parser.implementation Lexer.real_token lexbuf in *)
    let parsed = Parse.implementation lexbuf in
    close_in inc;
    parsed

(** Previous content of the interp.ml file *)
type env_flag = Open of Longident.t

let stdlib_flag = Open (Longident.Lident "Stdlib")
let no_stdlib_flag = []

let stdlib_units =
  (* let stdlib_path = stdlib_path () in *)
  [(no_stdlib_flag, "stdlib.py")]

let eval_env_flag ~loc env flag =
  match flag with
  | Open module_ident ->
     let module_ident = Location.mkloc module_ident loc in
     env_extend false env (env_get_module_data env module_ident)

(* let debug = true *)
let debug = false

let load_rec_units env flags_and_units =
  let unit_paths = List.map snd flags_and_units in
  let env = List.fold_left declare_unit env unit_paths in
  List.fold_left
    (fun global_env (flags, unit_path) ->
      let module_name = module_name_of_unit_path unit_path in
      if debug then begin
        print_endline ("Loading " ^ module_name ^ " from " ^ unit_path);
      end;
      let module_contents =
        let loc = Location.in_file unit_path in
        let local_env = List.fold_left (eval_env_flag ~loc) global_env flags in
        eval_structure Primitives.prims local_env (parse_file unit_path)
      in
      define_unit global_env unit_path (make_module_data module_contents))
    env
    flags_and_units

let stdlib_env =
  let env = Runtime_base.initial_env in
  let env = load_rec_units env stdlib_units in
  eval_env_flag env ~loc:Location.none stdlib_flag

let shift = ref false and alpha = ref false

let state_bg_color = color_green

let draw_state () =
  display_push_rect_uniform state_bg_color 290 0 30 15;
  if !shift then display_draw_string_small "white/green s" 295 1;
  if !alpha then display_draw_string_small "a" 310 1

let draw_bg () =
  clear_screen ();
  draw_state ()

(* Read in [R]EPL *)
let read () =
  let add_char c l =
    print_string c; c::l
  in
  let remove_char l =
    match l with
    | [] -> []
    | _::tl ->
      erase_char ();
      tl
  in
  let rec aux l =
    let k = Keyboard.wait_key_press () in
    match k with
    | Key_home -> raise Exit
    | Key_back -> draw_bg (); print_newline (); print_string "> "; aux []
    | Key_alpha -> alpha := not !alpha; draw_state (); aux l
    | Key_shift -> shift := not !shift; draw_state (); aux l
    | Key_exe ->
      (match l with
       | ";"::";"::tl -> List.rev tl
       | _ -> aux (add_char "\n" l)
      )
    | Key_backspace when not !alpha -> aux (remove_char l)
    | _ ->
      try
        if !alpha then
          let s = String.make 1 (alpha_char_of_key k) in
          let s = if !shift then String.capitalize_ascii s else s
          in aux (add_char s l)
        else if !shift then aux (add_char (shift_char_of_key k) l)
        else aux (add_char (String.make 1 (char_of_key k)) l)
      with _ -> aux l
  in String.concat "" (aux [])

(* Eval in R[E]PL *)
let eval env cmd =
    try
      if String.length cmd > 4 && String.sub cmd 0 4 = "%use" then
        let ss = String.split_on_char ' ' (String.sub cmd 4 (String.length cmd - 4)) in
        let filename = List.find (fun s -> s <> "") ss in
        let exp = parse_file filename in
        eval_structure Primitives.prims env exp
      else
        let exp = parse_string cmd in
        eval_structure Primitives.prims env exp
    with
    | InternalException e ->
      print_endline ("Internal Exn: " ^ (string_of_value e));
      env
    | Not_found -> env

let () =
  draw_bg ();
  print_endline "Camlboot for Numworks 1.0";
  print_endline "%use file.py;; to load a file";
  (* Loop in REP[L] *)
  let rec loop env =
    print_newline ();
    print_string "> ";
    let cmd = read () in
    print_newline ();
    let env = eval env cmd in
    loop env
  in loop stdlib_env
