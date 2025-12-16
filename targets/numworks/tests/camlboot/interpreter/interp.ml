open Data
open Conf
open Eval
open Envir

let parse_string str =
  let lexbuf = Lexing.from_string str in
  Location.init lexbuf "";
  Parse.implementation lexbuf

let parse_file filename =
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

  let stdlib = {|

external raise : exn -> 'a = "%raise"

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

(* Printing *)

external print_string : string -> unit = "%print_string"
external print_int : int -> unit = "%print_int"
external print_float : float -> unit = "%print_float"

(* OMicroB prims *)

external millis : unit -> int = "omicrob_millis"
|}

  and list = {|
(* An alias for the type of lists. *)
type 'a t = 'a list = [] | (::) of 'a * 'a list

(* List operations *)

let rec length_aux len = function
    [] -> len
  | _::l -> length_aux (len + 1) l

let length l = length_aux 0 l

let cons a l = a::l

let singleton a = [a]

let hd = function
    [] -> failwith "hd"
  | a::_ -> a

let tl = function
    [] -> failwith "tl"
  | _::l -> l

let nth l n =
  if n < 0 then invalid_arg "List.nth" else
  let rec nth_aux l n =
    match l with
    | [] -> failwith "nth"
    | a::l -> if n = 0 then a else nth_aux l (n-1)
  in nth_aux l n

let nth_opt l n =
  if n < 0 then invalid_arg "List.nth" else
  let rec nth_aux l n =
    match l with
    | [] -> None
    | a::l -> if n = 0 then Some a else nth_aux l (n-1)
  in nth_aux l n

let rec (@) l1 l2 =
  match l1 with
  | [] -> l2
  | h1 :: [] -> h1 :: l2
  | h1 :: h2 :: [] -> h1 :: h2 :: l2
  | h1 :: h2 :: h3 :: tl -> h1 :: h2 :: h3 :: (tl @ l2)

let append = (@)

let rec rev_append l1 l2 =
  match l1 with
    [] -> l2
  | a :: l -> rev_append l (a :: l2)

let rev l = rev_append l []

let[@tail_mod_cons] rec init i last f =
  if i > last then []
  else if i = last then [f i]
  else
    let r1 = f i in
    let r2 = f (i+1) in
    r1 :: r2 :: init (i+2) last f

let init len f =
  if len < 0 then invalid_arg "List.init" else
  init 0 (len - 1) f

let rec flatten = function
    [] -> []
  | l::r -> l @ flatten r

let concat = flatten

let[@tail_mod_cons] rec map f = function
    [] -> []
  | [a1] ->
      let r1 = f a1 in
      [r1]
  | a1::a2::l ->
      let r1 = f a1 in
      let r2 = f a2 in
      r1::r2::map f l

let[@tail_mod_cons] rec mapi i f = function
    [] -> []
  | [a1] ->
      let r1 = f i a1 in
      [r1]
  | a1::a2::l ->
      let r1 = f i a1 in
      let r2 = f (i+1) a2 in
      r1::r2::mapi (i+2) f l

let mapi f l = mapi 0 f l

let rev_map f l =
  let rec rmap_f accu = function
    | [] -> accu
    | a::l -> rmap_f (f a :: accu) l
  in
  rmap_f [] l

let rec iter f = function
    [] -> ()
  | a::l -> f a; iter f l

let rec iteri i f = function
    [] -> ()
  | a::l -> f i a; iteri (i + 1) f l

let iteri f l = iteri 0 f l

let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l

let rec fold_right f l accu =
  match l with
    [] -> accu
  | a::l -> f a (fold_right f l accu)
|}

in
[(no_stdlib_flag, "stdlib.ml", stdlib);
 (* ([stdlib_flag], "list.ml", list) *)]

let eval_env_flag ~loc env flag =
  match flag with
  | Open module_ident ->
     let module_ident = Location.mkloc module_ident loc in
     env_extend false env (env_get_module_data env module_ident)

(* let debug = true *)
let debug = false

let load_rec_units env flags_and_units =
  let unit_paths = List.map (fun (_, path, _) -> path) flags_and_units in
  let env = List.fold_left declare_unit env unit_paths in
  List.fold_left
    (fun global_env (flags, unit_path, unit_content) ->
      let module_name = module_name_of_unit_path unit_path in
      if debug then begin
        print_endline ("Loading " ^ module_name ^ " from " ^ unit_path);
      end;
      let module_contents =
        let loc = Location.in_file unit_path in
        let local_env = List.fold_left (eval_env_flag ~loc) global_env flags in
        eval_structure Primitives.prims local_env (parse_string unit_content)
      in
      define_unit global_env unit_path (make_module_data module_contents))
    env
    flags_and_units

let stdlib_env =
  let env = Runtime_base.initial_env in
  let env = load_rec_units env stdlib_units in
  eval_env_flag env ~loc:Location.none stdlib_flag

let shift = ref false and alpha = ref false

let state_bg_color = Color.make 29 15 1

let draw_state () =
  Screen.fill_rect state_bg_color 290 0 30 15;
  if !shift then Screen.print_full "s" 295 1 false Color.white state_bg_color;
  if !alpha then Screen.print_full "a" 310 1 false Color.white state_bg_color

let draw_bg () =
  Screen.clear ();
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
    let open Key in
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
          let s = String.make 1 (Key.to_alpha_char k) in
          let s = if !shift then String.capitalize_ascii s else s
          in aux (add_char s l)
        else if !shift then aux (add_char (Key.to_shift_char k) l)
        else aux (add_char (String.make 1 (Key.to_char k)) l)
      with _ -> aux l
  in String.concat "" (aux [])

let exc_to_string = function
    | Parsing.Parse_error -> "Parse error"
    | Syntaxerr.Error _ -> "Syntax error"
    | Syntaxerr.Escape_error -> "Escape error"
    | InternalException e -> "Internal Exn: " ^ (string_of_value e)
    | Match_fail -> "Match Fail"
    | No_module_data -> "No module data"
    | Out_of_memory -> "Out of Memory"
    | Stack_overflow -> "Stack overflow"
    | Invalid_argument msg -> "Invalid argument " ^ msg
    | Not_found -> "Not found"
    | Data.Ptr.Null -> "Null Ptr"
    | Data.Ptr.Full -> "Full Ptr"
    | Failure msg -> "Failure " ^ msg
    | _ -> "Unknown Exception"

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
    | e -> print_endline (exc_to_string e); env

let () =
  draw_bg ();
  print_endline "Camlboot for Numworks 1.0";
  print_endline "%use file.py;; to load a file";

  (* let _ = eval stdlib_env "%use bench.py" in *)

  (* Loop in REP[L] *)
  let rec loop env =
    print_newline ();
    print_string "> ";
    let cmd = read () in
    print_newline ();
    let env = eval env cmd in
    loop env
  in loop stdlib_env
