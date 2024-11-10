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

let color_black : int = 0x0
let color_white : int = 0xFFFF
let color_red : int = 0xF800
let color_green : int = 0x07E0
let color_blue : int = 0x001F

let screen_width = 320
let screen_height = 240

external display_draw_string : string -> int -> int -> unit = "caml_display_draw_string" [@@noalloc]
external display_draw_string_small : string -> int -> int -> unit = "caml_display_draw_string_small" [@@noalloc]
(* let display_draw_string_large = display_draw_string  (\* an alias only *\) *)

(* FIXME: it RESETs the calculator! *)
(* external display_draw_string_full : string -> int -> int -> bool -> int -> int -> unit = "caml_display_draw_string_full" [@@noalloc] *)

external display_push_rect_uniform : int -> int -> int -> int -> int -> unit = "caml_display_push_rect_uniform" [@@noalloc]

external display_push_allscreen_uniform : int -> unit = "caml_display_push_allscreen_uniform" [@@noalloc]

(***********************)
(* High-Level Printing *)
(***********************)

let cursorX = ref 0 and cursorY = ref 0

let clear_screen () =
  cursorX := 0;
  cursorY := 0;
  display_push_allscreen_uniform color_white

let clear_black_screen () =
  cursorX := 0;
  cursorY := 0;
  display_push_allscreen_uniform color_black

let print_string s =
  display_draw_string s !cursorX !cursorY;
  cursorX := !cursorX + 10 * (String.length s)

let print_newline () =
  print_string "\n"; (* If in simu *)
  cursorX := 0;
  cursorY := !cursorY + 16

let print_endline s = print_string s; print_newline ()

let print_int i = print_string (string_of_int i)

let print_bool b =
  if b = true then print_string "true"
  else print_string "false"
;;

let print_char c = print_string (String.make 1 c);;
let print_float f = print_string (string_of_float f);;

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

(*******************)
(* Storage library *)
(*******************)

external read_any_file : string -> string = "caml_read_any_file"

let cat_any_file s =
  print_endline ("Reading from "^s);
  print_string (read_any_file  s)

let cat_ocamlpy_file () =
  cat_any_file "ocaml.py"
;;

let read_ocamlpy_file () =
  read_any_file "ocaml.py"
;;
