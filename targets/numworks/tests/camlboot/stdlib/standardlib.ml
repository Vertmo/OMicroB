(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

module Pervasives = struct
(* type 'a option = None | Some of 'a *)

(* Exceptions *)

(* external register_named_value : string -> 'a -> unit
                              = "caml_register_named_value" *)

(* let () =
  (* for asmrun/fail.c *)
  register_named_value "Pervasives.array_bound_error"
    (Invalid_argument "index out of bounds") *)


external raise : exn -> 'a = "%raise"
external raise_notrace : exn -> 'a = "%raise_notrace"

let failwith s = raise(Failure s)
let invalid_arg s = raise(Invalid_argument s)

exception Exit

(* Composition operators *)

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"
external ( @@ ) : ('a -> 'b) -> 'a -> 'b = "%apply"

(* Debugging *)

external __LOC__ : string = "%loc_LOC"
external __FILE__ : string = "%loc_FILE"
external __LINE__ : int = "%loc_LINE"
external __MODULE__ : string = "%loc_MODULE"
external __POS__ : string * int * int * int = "%loc_POS"

external __LOC_OF__ : 'a -> string * 'a = "%loc_LOC"
external __LINE_OF__ : 'a -> int * 'a = "%loc_LINE"
external __POS_OF__ : 'a -> (string * int * int * int) * 'a = "%loc_POS"

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

(* let () = print_endline "Defining manually infinity, neg_infinity, nan, max_float, min_float, epsilon_float" *)

(* The following constants are defined manually to avoid using the
   float_of_bits primitive which is not available in all OCaml
   versions. *)

(* These values are based on the IEEE 754 double-precision floating-point
   representation. *)

(* Uncomment the following lines if you want to use float_of_bits directly.
   Note that this requires a specific OCaml version that supports it. *)
(* external float_of_bits : int64 -> float
  = "caml_int64_float_of_bits" "caml_int64_float_of_bits_unboxed"
  [@@unboxed] [@@noalloc] *)

(* let infinity =
  float_of_bits 0x7F_F0_00_00_00_00_00_00L *)
(* let infinity = float_of_string "+inf" *)

(* let neg_infinity =
  float_of_bits 0xFF_F0_00_00_00_00_00_00L *)
(* let neg_infinity = float_of_string "-inf" *)

(* let nan =
  float_of_bits 0x7F_F0_00_00_00_00_00_01L *)
(* let nan = float_of_string "nan" *)

(* let max_float =
  float_of_bits 0x7F_EF_FF_FF_FF_FF_FF_FFL *)

let max_float = 1.79769313486231571e+308
(* let min_float =
  float_of_bits 0x00_10_00_00_00_00_00_00L *)

let min_float = 2.22507385850720138e-308
(* let epsilon_float =
  float_of_bits 0x3C_B0_00_00_00_00_00_00L *)

let epsilon_float = 2.22044604925031308e-16

type fpclass =
    FP_normal
  | FP_subnormal
  | FP_zero
  | FP_infinite
  | FP_nan
external classify_float : (float [@unboxed]) -> fpclass =
  "caml_classify_float" "caml_classify_float_unboxed" [@@noalloc]

(* String and byte sequence operations -- more in modules String and Bytes *)

external string_length : string -> int = "%string_length"
external bytes_length : bytes -> int = "%bytes_length"
external bytes_create : int -> bytes = "caml_create_bytes"
external string_blit : string -> int -> bytes -> int -> int -> unit
                     = "caml_blit_string" [@@noalloc]
external bytes_blit : bytes -> int -> bytes -> int -> int -> unit
                        = "caml_blit_bytes" [@@noalloc]
external bytes_unsafe_to_string : bytes -> string = "%bytes_to_string"

let ( ^ ) s1 s2 =
  let l1 = string_length s1 and l2 = string_length s2 in
  let s = bytes_create (l1 + l2) in
  string_blit s1 0 s 0 l1;
  string_blit s2 0 s l1 l2;
  bytes_unsafe_to_string s

(* Character operations -- more in module Char *)

external int_of_char : char -> int = "%identity"
external unsafe_char_of_int : int -> char = "%identity"
let char_of_int n =
  if n < 0 || n > 255 then invalid_arg "char_of_int" else unsafe_char_of_int n

(*
(* Formats *)

type ('a, 'b, 'c, 'd, 'e, 'f) format6
   = ('a, 'b, 'c, 'd, 'e, 'f) CamlinternalFormatBasics.format6
   = Format of ('a, 'b, 'c, 'd, 'e, 'f) CamlinternalFormatBasics.fmt
               * string

type ('a, 'b, 'c, 'd) format4 = ('a, 'b, 'c, 'c, 'c, 'd) format6

type ('a, 'b, 'c) format = ('a, 'b, 'c, 'c) format4

let string_of_format (Format (_fmt, str)) = str

external format_of_string :
 ('a, 'b, 'c, 'd, 'e, 'f) format6 ->
 ('a, 'b, 'c, 'd, 'e, 'f) format6 = "%identity"

let ( ^^ ) (Format (fmt1, str1)) (Format (fmt2, str2)) =
  Format (CamlinternalFormatBasics.concat_fmt fmt1 fmt2,
          str1 ^ "%," ^ str2)
*)

(* Unit operations *)

external ignore : 'a -> unit = "%ignore"

(* Pair operations *)

external fst : 'a * 'b -> 'a = "%field0"
external snd : 'a * 'b -> 'b = "%field1"

(* References *)

type 'a ref = { mutable contents : 'a }
external ref : 'a -> 'a ref = "%makemutable"
external ( ! ) : 'a ref -> 'a = "%field0"
external ( := ) : 'a ref -> 'a -> unit = "%setfield0"
external incr : int ref -> unit = "%incr"
external decr : int ref -> unit = "%decr"

(* Result type *)

type ('a,'b) result = Ok of 'a | Error of 'b

(* String conversion functions *)

external format_int : string -> int -> string = "caml_format_int"
external format_float : string -> float -> string = "caml_format_float"

let string_of_bool b =
  if b then "true" else "false"
let bool_of_string = function
  | "true" -> true
  | "false" -> false
  | _ -> invalid_arg "bool_of_string"

let bool_of_string_opt = function
  | "true" -> Some true
  | "false" -> Some false
  | _ -> None

let string_of_int n =
  format_int "%d" n

external int_of_string : string -> int = "caml_int_of_string"

let int_of_string_opt s =
  (* TODO: provide this directly as a non-raising primitive. *)
  try Some (int_of_string s)
  with Failure _ -> None

external string_get : string -> int -> char = "%string_safe_get"

let valid_float_lexem s =
  let l = string_length s in
  let rec loop i =
    if i >= l then s ^ "." else
    match string_get s i with
    | '0' .. '9' | '-' -> loop (i + 1)
    | _ -> s
  in
  loop 0

let string_of_float f = valid_float_lexem (format_float "%.12g" f)

(* external float_of_string : string -> float = "caml_float_of_string" *)
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


let float_of_string_opt s =
  (* TODO: provide this directly as a non-raising primitive. *)
  try Some (float_of_string s)
  with Failure _ -> None

(* List operations -- more in module List *)

let rec ( @ ) l1 l2 =
  match l1 with
    [] -> l2
  | hd :: tl -> hd :: (tl @ l2)

(* Miscellaneous *)

external sys_exit : int -> 'a = "caml_sys_exit"

let exit_function = ref (fun () -> ())

let at_exit f =
  let g = !exit_function in
  (* MPR#7253, MPR#7796: make sure "f" is executed only once *)
  let f_already_ran = ref false in
  exit_function :=
    (fun () ->
      if not !f_already_ran then begin f_already_ran := true; f() end;
      g())

let do_at_exit () = (!exit_function) ()

let exit retcode =
  do_at_exit ();
  sys_exit retcode

(* let _ = register_named_value "Pervasives.do_at_exit" do_at_exit *)
end

include Pervasives

(* MODULE_ALIASES *)
(* module Arg          = Arg
module Array        = Array
(* module ArrayLabels  = ArrayLabels *)
(* module Bigarray     = Bigarray *)
module Buffer       = Buffer
module Bytes        = Bytes
(* module BytesLabels  = BytesLabels *)
module Callback     = Callback
module Char         = Char
module Complex      = Complex
module Digest       = Digest
module Ephemeron    = Ephemeron
module Filename     = Filename
module Float        = Float
(* module Format       = Format *)
module Gc           = Gc
module Genlex       = Genlex
module Hashtbl      = Hashtbl
(* module Int32        = Int32 *)
(* module Int64        = Int64 *)
module Lazy         = Lazy
module Lexing       = Lexing
module List         = List
(* module ListLabels   = ListLabels *)
module Map          = Map
module Marshal      = Marshal
(* module MoreLabels   = MoreLabels *)
(* module Nativeint    = Nativeint *)
module Obj          = Obj
module Oo           = Oo
module Parsing      = Parsing
module Printexc     = Printexc
module Printf       = Printf
module Queue        = Queue
(* module Random       = Random *)
(* module Scanf        = Scanf *)
module Seq          = Seq
module Set          = Set
module Sort         = Sort
(* module Spacetime    = Spacetime *)
module Stack        = Stack
(* module StdLabels    = StdLabels *)
module Stream       = Stream
module String       = String
(* module StringLabels = StringLabels *)
(* module Sys          = Sys *)
module Uchar        = Uchar
module Weak         = Weak *)