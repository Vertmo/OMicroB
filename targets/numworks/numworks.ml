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

let prerr_char c = print_char c;;
let prerr_string s = print_string s;;
let prerr_int i = print_int i;;
let prerr_float f = print_float f;;
let prerr_bool f = print_bool f;;
let prerr_endline s = print_endline s;;
let prerr_newline () = print_newline ();;

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

(****************************************)
(* Copied content of the stdlib.ml file *)
(****************************************)

(* I/O operations *)

type in_channel
type out_channel

external open_descriptor_out : int -> out_channel = "numworks_caml_ml_open_descriptor_out" [@@noalloc]
external open_descriptor_in : int -> in_channel = "numworks_caml_ml_open_descriptor_in" [@@noalloc]

let stdin = open_descriptor_in 0
let stdout = open_descriptor_out 1
let stderr = open_descriptor_out 2

(* General output functions *)

type open_flag =
  Open_rdonly | Open_wronly | Open_append
| Open_creat | Open_trunc | Open_excl
| Open_binary | Open_text | Open_nonblock

let open_out_gen _mode _perm _name =
  failwith "TODO open_out_gen"
(* open_descriptor_out (open_desc name mode perm) *)

let open_out name =
  open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_text] 0o666 name

let open_out_bin name =
  open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_binary] 0o666 name

let flush _ = () (* Every operation flushes anyway *)
let flush_all () = ()

let output_string oc s =
  if oc = stdout || oc = stderr then print_string s
  else print_endline "FIXME output_string"

let output_bytes oc b = output_string oc (Bytes.unsafe_to_string b)

let output_char oc c = output_string oc (String.make 1 c)

let output oc s ofs len =
  if ofs < 0 || len < 0 || ofs > Bytes.length s - len
  then invalid_arg "output"
  else output_bytes oc (Bytes.sub s ofs len)

let output_substring oc s ofs len =
  if ofs < 0 || len < 0 || ofs > String.length s - len
  then invalid_arg "output_substring"
  else output_string oc (String.sub s ofs len)

let close_out oc = flush oc
let close_out_noerr oc = try flush oc with _ -> ()


(* Output functions on standard output *)

let print_bytes s = print_string (Bytes.unsafe_to_string s)

(* Output functions on standard error *)

let prerr_bytes s = (* TODO with the correct color *)
  print_bytes s

(* General input functions *)

(* external open_in_gen : _ list -> _ -> string -> in_channel = "caml_ml_open_in_gen" *)

external open_in : string -> in_channel = "numworks_ml_open_in"

(* let open_in_bin name = *)
(*   open_in_gen [Open_rdonly; Open_binary] 0 name *)

external input_char : in_channel -> char = "numworks_ml_input_char"
external unsafe_input : in_channel -> bytes -> int -> int -> int = "numworks_ml_input"

(* external input_scan_line : in_channel -> int = "caml_ml_input_scan_line" *)

(* let input_line chan = *)
(*   let rec build_result buf pos = function *)
(*     [] -> buf *)
(*   | hd :: tl -> *)
(*       let len = Bytes.length hd in *)
(*       Bytes.unsafe_blit hd 0 buf (pos - len) len; *)
(*       build_result buf (pos - len) tl in *)
(*   let rec scan accu len = *)
(*     let n = input_scan_line chan in *)
(*     if n = 0 then begin                   (\* n = 0: we are at EOF *\) *)
(*       match accu with *)
(*         [] -> raise End_of_file *)
(*       | _  -> build_result (Bytes.create len) len accu *)
(*     end else if n > 0 then begin          (\* n > 0: newline found in buffer *\) *)
(*       let res = Bytes.create (n - 1) in *)
(*       ignore (unsafe_input chan res 0 (n - 1)); *)
(*       ignore (input_char chan);           (\* skip the newline *\) *)
(*       match accu with *)
(*         [] -> res *)
(*       |  _ -> let len = len + n - 1 in *)
(*               build_result (Bytes.create len) len (res :: accu) *)
(*     end else begin                        (\* n < 0: newline not found *\) *)
(*       let beg = Bytes.create (-n) in *)
(*       ignore(unsafe_input chan beg 0 (-n)); *)
(*       scan (beg :: accu) (len - n) *)
(*     end *)
(*   in Bytes.unsafe_to_string (scan [] 0) *)

(* external input_value : in_channel -> 'a = "caml_input_value" *)
external close_in : in_channel -> unit = "numworks_ml_close_in"

external seek_in : in_channel -> int -> unit = "caml_ml_seek_in"
external pos_in : in_channel -> int = "caml_ml_pos_in"

external in_channel_length : in_channel -> int = "caml_ml_channel_size"

let input ic s ofs len =
  if ofs < 0 || len < 0 || ofs > Bytes.length s - len
  then invalid_arg "input"
  else unsafe_input ic s ofs len

let rec unsafe_really_input ic s ofs len =
  if len <= 0 then () else begin
    let r = unsafe_input ic s ofs len in
    if r = 0
    then raise End_of_file
    else unsafe_really_input ic s (ofs + r) (len - r)
  end

let really_input ic s ofs len =
  if ofs < 0 || len < 0 || ofs > Bytes.length s - len
  then invalid_arg "really_input"
  else unsafe_really_input ic s ofs len

let really_input_string ic len =
  let s = Bytes.create len in
  really_input ic s 0 len;
  Bytes.unsafe_to_string s
