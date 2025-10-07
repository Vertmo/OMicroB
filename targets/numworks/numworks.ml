(**********************************)
(** Code of the Numworks library **)
(**********************************)

(**********)
(* Timing *)
(**********)

(** delay ms : sleeps for this amount of milliseconds. *)
external delay : int -> unit = "caml_delay" [@@noalloc]

(** delay us : sleeps for this amount of microseconds. *)
external delay_usec : int -> unit = "caml_delay_usec" [@@noalloc]

(** millis () : gives the amount of milliseconds since launching the program/machine
    (detail is not important, only difference between two millis() is useful). *)
external millis : unit -> int = "caml_millis" [@@noalloc]


(***********************************)
(* Functions from the EADK library *)
(***********************************)

(* 15-bit colors *)
type color = int

(* Values should be between 0 and 1F *)
let mk_color r g b =
  (r lsl 11) + ((2 * g) lsl 5) + b

let color_black : int = mk_color 0 0 0
let color_white : int = mk_color 31 31 31
let color_red : int = mk_color 31 0 0
let color_green : int = mk_color 0 31 0
let color_blue : int = mk_color 0 0 31

let screen_width = 320
let screen_height = 240

external display_draw_string_full' : string -> int -> int -> bool -> (color * color) -> unit = "caml_display_draw_string_full" [@@noalloc]

let display_draw_string_full text x y size tcolor bgcolor =
  display_draw_string_full' text x y size (tcolor, bgcolor)

let display_draw_string s x y =
  display_draw_string_full' s x y true (color_black, color_white)

let display_draw_string_small s x y =
  display_draw_string_full' s x y false (color_black, color_white)

external display_draw_rect : color -> int -> int -> int -> int -> unit = "caml_display_push_rect_uniform" [@@noalloc]

external display_fill_screen : color -> unit = "caml_display_push_allscreen_uniform" [@@noalloc]

(***********************)
(* High-Level Printing *)
(***********************)

let cursorX = ref 0 and cursorY = ref 0

let clear_screen () =
  cursorX := 0;
  cursorY := 0;
  display_fill_screen color_white

let clear_black_screen () =
  cursorX := 0;
  cursorY := 0;
  display_fill_screen color_black

let print_newline () =
  display_draw_string "\n" !cursorX !cursorY;
  cursorX := 0;
  cursorY := !cursorY + 16

let print_string s =
  let rec aux ss =
    match ss with
    | [] -> ()
    | [s] ->
       display_draw_string s !cursorX !cursorY;
       cursorX := !cursorX + 10 * (String.length s)
    | s::tl ->
       display_draw_string s !cursorX !cursorY;
       print_newline ();
       aux tl
  in aux (String.split_on_char '\n' s)

let print_endline s =
  print_string s; print_newline ()

let print_int i = print_string (string_of_int i)

let print_bool b =
  if b = true then print_string "true"
  else print_string "false"
;;

let print_char c = print_string (String.make 1 c);;
let print_float f = print_string (string_of_float f);;

let prerr_char c = print_char c;;
let prerr_string s = print_string s;;
let prerr_int i = print_int i;;
let prerr_float f = print_float f;;
let prerr_bool f = print_bool f;;
let prerr_endline s = print_endline s;;
let prerr_newline () = print_newline ();;

let erase_char () =
  if (!cursorX = 0) then failwith "TODO"
  else cursorX := !cursorX - 10;
  display_draw_string " " !cursorX !cursorY

(* TODO should be able to scroll screen *)

(*************)
(* Backlight *)
(*************)

external backlight_set_brightness : int -> unit = "caml_backlight_set_brightness" [@@noalloc]
external backlight_brightness : unit -> int = "caml_backlight_brightness" [@@noalloc]


(***********)
(* Battery *)
(***********)

(* external battery_is_charging : unit -> bool = "caml_battery_is_charging" [@@noalloc] *)
(* external battery_level : unit -> int = "caml_battery_level" [@@noalloc] *)
(* external battery_voltage : unit -> float = "caml_battery_voltage" [@@noalloc] *)


(********)
(* Misc *)
(********)

external random : unit -> int = "caml_random" [@@noalloc]
(* external usb_is_plugged : unit -> bool = "caml_usb_is_plugged" [@@noalloc] *)

let exit (_:int) = ()

(****************************************)
(* Implementation of IO from stdlib     *)
(****************************************)

(** {2 General output functions} *)
(* TODO *)

type out_channel

type open_flag =
  Open_rdonly | Open_wronly | Open_append
| Open_creat | Open_trunc | Open_excl
| Open_binary | Open_text | Open_nonblock

(* let open_out_gen _mode _perm _name = *)
(*   failwith "TODO open_out_gen" *)
(* (\* open_descriptor_out (open_desc name mode perm) *\) *)

(* let open_out name = *)
(*   open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_text] 0o666 name *)

(* let open_out_bin name = *)
(*   open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_binary] 0o666 name *)

(* let flush _ = () (\* Every operation flushes anyway *\) *)
(* let flush_all () = () *)

(* let output_string oc s = print_string s *)

(* let output_bytes oc b = output_string oc (Bytes.unsafe_to_string b) *)

(* let output_char oc c = output_string oc (String.make 1 c) *)

(* let output oc s ofs len = *)
(*   if ofs < 0 || len < 0 || ofs > Bytes.length s - len *)
(*   then invalid_arg "output" *)
(*   else output_bytes oc (Bytes.sub s ofs len) *)

(* let output_substring oc s ofs len = *)
(*   if ofs < 0 || len < 0 || ofs > String.length s - len *)
(*   then invalid_arg "output_substring" *)
(*   else output_string oc (String.sub s ofs len) *)

(* let close_out oc = flush oc *)
(* let close_out_noerr oc = try flush oc with _ -> () *)

(* Output functions on standard output *)

let print_bytes s = print_string (Bytes.unsafe_to_string s)

(* Output functions on standard error *)

let prerr_bytes s = (* TODO with the correct color *)
  print_bytes s

(** {2 General input functions} *)

type in_channel

external open_in : string -> in_channel = "numworks_ml_open_in"

external input_char : in_channel -> char = "numworks_ml_input_char"
external unsafe_input : in_channel -> bytes -> int -> int -> int = "numworks_ml_input"

external close_in : in_channel -> unit = "numworks_ml_close_in"

let input ic s ofs len =
  if ofs < 0 || len < 0 || ofs > Bytes.length s - len
  then invalid_arg "input"
  else unsafe_input ic s ofs len

(********)
(* Keys *)
(********)

type key =
  | Key_left
  | Key_up
  | Key_down
  | Key_right
  | Key_ok
  | Key_back
  | Key_home
  | Key_on_off
  | Key_shift
  | Key_alpha
  | Key_xnt
  | Key_var
  | Key_toolbox
  | Key_backspace
  | Key_exp
  | Key_ln
  | Key_log
  | Key_imaginary
  | Key_comma
  | Key_power
  | Key_sine
  | Key_cosine
  | Key_tangent
  | Key_pi
  | Key_sqrt
  | Key_square
  | Key_seven
  | Key_eight
  | Key_nine
  | Key_left_parenthesis
  | Key_right_parenthesis
  | Key_four
  | Key_five
  | Key_six
  | Key_multiplication
  | Key_division
  | Key_one
  | Key_two
  | Key_three
  | Key_plus
  | Key_minus
  | Key_zero
  | Key_dot
  | Key_ee
  | Key_ans
  | Key_exe

let key_of_char c =
  match c with
  | 'a' | 'A' -> Key_exp
  | 'b' | 'B' -> Key_ln
  | 'c' | 'C' -> Key_log
  | 'd' | 'D' -> Key_imaginary
  | 'e' | 'E' -> Key_comma
  | 'f' | 'F' -> Key_power
  | 'g' | 'G' -> Key_sine
  | 'h' | 'H' -> Key_cosine
  | 'i' | 'I' -> Key_tangent
  | 'j' | 'J' -> Key_pi
  | 'k' | 'K' -> Key_sqrt
  | 'l' | 'L' -> Key_square
  | 'm' | 'M' -> Key_seven
  | 'n' | 'N' -> Key_eight
  | 'o' | 'O' -> Key_nine
  | 'p' | 'P' -> Key_left_parenthesis
  | 'q' | 'Q' -> Key_right_parenthesis
  | 'r' | 'R' -> Key_four
  | 's' | 'S' -> Key_five
  | 't' | 'T' -> Key_six
  | 'u' | 'U' -> Key_multiplication
  | 'v' | 'V' -> Key_division
  | 'w' | 'W' -> Key_one
  | 'x' | 'X' -> Key_two
  | 'y' | 'Y' -> Key_three
  | 'z' | 'Z' -> Key_plus
  | ' ' -> Key_minus
  | '?' -> Key_zero
  | '!' -> Key_dot
  | _ -> invalid_arg "key_of_char"

let char_of_key k =
  match k with
  | Key_one -> '1'
  | Key_two -> '2'
  | Key_three -> '3'
  | Key_four -> '4'
  | Key_five -> '5'
  | Key_six -> '6'
  | Key_seven -> '7'
  | Key_eight -> '8'
  | Key_nine -> '9'
  | Key_zero -> '0'
  | Key_left_parenthesis -> '('
  | Key_right_parenthesis -> ')'
  | Key_multiplication -> '*'
  | Key_division -> '/'
  | Key_plus -> '+'
  | Key_minus -> '-'
  | Key_dot -> '.'
  | Key_xnt
  | Key_var
  | Key_toolbox
  | Key_backspace
  | Key_exp
  | Key_ln
  | Key_log
  | Key_imaginary
  | Key_comma
  | Key_power
  | Key_sine
  | Key_cosine
  | Key_tangent
  | Key_pi
  | Key_sqrt
  | Key_square
  | Key_left
  | Key_up
  | Key_down
  | Key_right
  | Key_ok
  | Key_back
  | Key_home
  | Key_on_off
  | Key_shift
  | Key_alpha
  | Key_ee
  | Key_ans
  | Key_exe ->  invalid_arg "char_of_key"

let shift_char_of_key k =
  match k with
  | Key_exp -> "["
  | Key_ln -> "]"
  | Key_log -> "{"
  | Key_imaginary -> "}"
  | Key_comma -> "_"
  | Key_power -> "->"
  | Key_pi -> "="
  | Key_sqrt -> "<"
  | Key_square -> ">"
  | Key_seven
  | Key_eight
  | Key_nine
  | Key_left_parenthesis
  | Key_right_parenthesis
  | Key_four
  | Key_five
  | Key_six
  | Key_multiplication
  | Key_division
  | Key_one
  | Key_two
  | Key_three
  | Key_plus
  | Key_minus
  | Key_zero
  | Key_dot
  | Key_left
  | Key_up
  | Key_down
  | Key_right
  | Key_ok
  | Key_back
  | Key_home
  | Key_on_off
  | Key_shift
  | Key_alpha
  | Key_ee
  | Key_ans
  | Key_exe
  | Key_xnt
  | Key_var
  | Key_toolbox
  | Key_backspace
  | Key_sine
  | Key_cosine
  | Key_tangent -> invalid_arg "alpha_char_of_key"

let alpha_char_of_key k =
  match k with
  | Key_xnt -> ':'
  | Key_var -> ';'
  | Key_toolbox -> '"'
  | Key_backspace -> '%'
  | Key_exp -> 'a'
  | Key_ln -> 'b'
  | Key_log -> 'c'
  | Key_imaginary -> 'd'
  | Key_comma -> 'e'
  | Key_power -> 'f'
  | Key_sine -> 'g'
  | Key_cosine -> 'h'
  | Key_tangent -> 'i'
  | Key_pi -> 'j'
  | Key_sqrt -> 'k'
  | Key_square -> 'l'
  | Key_seven -> 'm'
  | Key_eight -> 'n'
  | Key_nine -> 'o'
  | Key_left_parenthesis -> 'p'
  | Key_right_parenthesis -> 'q'
  | Key_four -> 'r'
  | Key_five -> 's'
  | Key_six -> 't'
  | Key_multiplication -> 'u'
  | Key_division -> 'v'
  | Key_one -> 'w'
  | Key_two -> 'x'
  | Key_three -> 'y'
  | Key_plus -> 'z'
  | Key_minus -> ' '
  | Key_zero -> '?'
  | Key_dot -> '!'
  | Key_left
  | Key_up
  | Key_down
  | Key_right
  | Key_ok
  | Key_back
  | Key_home
  | Key_on_off
  | Key_shift
  | Key_alpha
  | Key_ee
  | Key_ans
  | Key_exe -> invalid_arg "alpha_char_of_key"

module Keyboard = struct

  type keyboard_state

  external numworks_scan : unit -> keyboard_state = "caml_numworks_keyboard_scan"
  external numworks_key_down : keyboard_state -> key -> bool = "caml_numworks_keyboard_key_down"

  let state = ref (numworks_scan ())

  let scan () = state := numworks_scan ()

  let key_down key = numworks_key_down !state key

  let all_keys : key list = List.init 46 (fun i -> Obj.magic i)

  let wait_key_press () =
    let rec aux state =
      let nstate = numworks_scan () in
      match List.find_opt (fun key -> numworks_key_down nstate key && not (numworks_key_down state key)) all_keys with
      | Some key -> key
      | None -> aux nstate
    in aux (numworks_scan ())
end


(******************************)
(* High-level storage library *)
(******************************)

let read_any_file filename =
  let ic = open_in filename in
  let bufsize = 100 in
  let rec aux l =
    let buf = Bytes.create bufsize in
    let i = unsafe_input ic buf 0 bufsize in
    let buf = if i < bufsize then
        let nbuf = Bytes.create i in
        Bytes.blit buf 0 nbuf 0 i;
        nbuf
      else buf in
    let l = buf::l in
    if i < bufsize then List.rev l else aux l
  in
  let s = Bytes.to_string (Bytes.concat Bytes.empty (aux [])) in
  close_in ic; s
