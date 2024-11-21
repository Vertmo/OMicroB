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

(* String and byte sequence operations -- more in modules String and Bytes *)

external string_length : string -> int = "%string_length"
external bytes_length : bytes -> int = "%bytes_length"
external bytes_create : int -> bytes = "caml_create_bytes"
external string_blit : string -> int -> bytes -> int -> int -> unit = "caml_blit_string" [@@noalloc]
external bytes_blit : bytes -> int -> bytes -> int -> int -> unit = "caml_blit_bytes" [@@noalloc]
external bytes_unsafe_to_string : bytes -> string = "%bytes_to_string"

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

external open_desc : string -> open_flag list -> int -> int = "caml_sys_open"

external set_out_channel_name: out_channel -> string -> unit = "caml_ml_set_channel_name"

let open_out_gen mode perm name =
  let c = open_descriptor_out(open_desc name mode perm) in
  print_endline "set_out_channel_name";
  set_out_channel_name c name;
  c

let open_out name =
  open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_text] 0o666 name

let open_out_bin name =
  open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_binary] 0o666 name

external flush : out_channel -> unit = "caml_ml_flush"

external out_channels_list : unit -> out_channel list
                         = "caml_ml_out_channels_list"

let flush_all () =
let rec iter = function
    [] -> ()
  | a::l ->
      begin try
          flush a
      with Sys_error _ ->
        () (* ignore channels closed during a preceding flush. *)
      end;
      iter l
in iter (out_channels_list ())

external unsafe_output : out_channel -> bytes -> int -> int -> unit
                     = "caml_ml_output_bytes"
external unsafe_output_string : out_channel -> string -> int -> int -> unit
                            = "caml_ml_output"

external output_char : out_channel -> char -> unit = "caml_ml_output_char"

let output_bytes oc s =
unsafe_output oc s 0 (bytes_length s)

let output_string oc s =
unsafe_output_string oc s 0 (string_length s)

let output oc s ofs len =
if ofs < 0 || len < 0 || ofs > bytes_length s - len
then invalid_arg "output"
else unsafe_output oc s ofs len

let output_substring oc s ofs len =
if ofs < 0 || len < 0 || ofs > string_length s - len
then invalid_arg "output_substring"
else unsafe_output_string oc s ofs len

external output_byte : out_channel -> int -> unit = "caml_ml_output_char"
external output_binary_int : out_channel -> int -> unit = "caml_ml_output_int"

external marshal_to_channel : out_channel -> 'a -> unit list -> unit
   = "caml_output_value"
let output_value chan v = marshal_to_channel chan v []

external seek_out : out_channel -> int -> unit = "caml_ml_seek_out"
external pos_out : out_channel -> int = "caml_ml_pos_out"
external out_channel_length : out_channel -> int = "caml_ml_channel_size"
external close_out_channel : out_channel -> unit = "caml_ml_close_channel"
let close_out oc = flush oc; close_out_channel oc
let close_out_noerr oc =
(try flush oc with _ -> ());
(try close_out_channel oc with _ -> ())
external set_binary_mode_out : out_channel -> bool -> unit
                           = "caml_ml_set_binary_mode"


(* Output functions on standard output *)

let print_bytes s = output_bytes (open_descriptor_out 1) s

(* Output functions on standard error *)

let prerr_bytes s = output_bytes (open_descriptor_out 2) s

(* General input functions *)

external set_in_channel_name: in_channel -> string -> unit =
  "caml_ml_set_channel_name"

let open_in_gen mode perm name =
  let c = open_descriptor_in(open_desc name mode perm) in
  set_in_channel_name c name;
  c

let open_in name =
  open_in_gen [Open_rdonly; Open_text] 0 name

let open_in_bin name =
  open_in_gen [Open_rdonly; Open_binary] 0 name

external input_char : in_channel -> char = "caml_ml_input_char"

external unsafe_input : in_channel -> bytes -> int -> int -> int
                      = "caml_ml_input"

external input_scan_line : in_channel -> int = "caml_ml_input_scan_line"

let input_line chan =
  let rec build_result buf pos = function
    [] -> buf
  | hd :: tl ->
      let len = bytes_length hd in
      bytes_blit hd 0 buf (pos - len) len;
      build_result buf (pos - len) tl in
  let rec scan accu len =
    let n = input_scan_line chan in
    if n = 0 then begin                   (* n = 0: we are at EOF *)
      match accu with
        [] -> raise End_of_file
      | _  -> build_result (bytes_create len) len accu
    end else if n > 0 then begin          (* n > 0: newline found in buffer *)
      let res = bytes_create (n - 1) in
      ignore (unsafe_input chan res 0 (n - 1));
      ignore (input_char chan);           (* skip the newline *)
      match accu with
        [] -> res
      |  _ -> let len = len + n - 1 in
              build_result (bytes_create len) len (res :: accu)
    end else begin                        (* n < 0: newline not found *)
      let beg = bytes_create (-n) in
      ignore(unsafe_input chan beg 0 (-n));
      scan (beg :: accu) (len - n)
    end
  in bytes_unsafe_to_string (scan [] 0)

external input_value : in_channel -> 'a = "caml_input_value"
external close_in : in_channel -> unit = "caml_ml_close_channel"

external input_byte : in_channel -> int = "caml_ml_input_char"
external input_binary_int : in_channel -> int = "caml_ml_input_int"
external input_value : in_channel -> 'a = "caml_input_value"
external seek_in : in_channel -> int -> unit = "caml_ml_seek_in"
external pos_in : in_channel -> int = "caml_ml_pos_in"

external in_channel_length : in_channel -> int = "caml_ml_channel_size"

let input ic s ofs len =
  if ofs < 0 || len < 0 || ofs > bytes_length s - len
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
  if ofs < 0 || len < 0 || ofs > bytes_length s - len
  then invalid_arg "really_input"
  else unsafe_really_input ic s ofs len

let really_input_string ic len =
  let s = bytes_create len in
  really_input ic s 0 len;
  bytes_unsafe_to_string s
