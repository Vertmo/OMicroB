(***************************************)
(** Signature of the Numworks library **)
(***************************************)

(**********)
(* Timing *)
(**********)

val delay : int -> unit
val delay_usec : int -> unit
val millis : unit -> int


(************)
(* Printing *)
(************)

val print_string : string -> unit
val print_newline : unit -> unit
val print_endline : string -> unit
val print_int : int -> unit
val print_bool : bool -> unit
val print_char : char -> unit
val print_float : float -> unit

val prerr_string : string -> unit
val prerr_newline : unit -> unit
val prerr_endline : string -> unit
val prerr_int : int -> unit
val prerr_bool : bool -> unit
val prerr_char : char -> unit
val prerr_float : float -> unit

val erase_char : unit -> unit

(***********************************)
(* Functions from the EADK library *)
(***********************************)

module Color : sig
    type t

    (* Values should be between 0 and 1F *)
    val make : int -> int -> int -> t

    val black : t
    val white : t
    val red : t
    val green : t
    val blue : t
end

module Screen : sig
    val width : int
    val height : int

    val draw_string_full : string -> int -> int -> bool -> Color.t -> Color.t -> unit
    val draw_string : string -> int -> int -> unit
    val draw_string_small : string -> int -> int -> unit

    val fill_rect : Color.t -> int -> int -> int -> int -> unit
    val fill_screen : Color.t -> unit
    val clear : unit -> unit
end


(*************)
(* Backlight *)
(*************)

module Backlight : sig
    val set_brightness : int -> unit
    val get_brightness : unit -> int
end

(***********)
(* Battery *)
(***********)

(* val battery_is_charging : unit -> bool *)
(* val battery_level : unit -> int *)
(* val battery_voltage : unit -> float *)


(********)
(* Misc *)
(********)

val random : unit -> int
(* val usb_is_plugged : unit -> bool *)
val exit : int -> unit

(*******************)
(* Storage library *)
(*******************)

val read_any_file : string -> string

(********)
(* Keys *)
(********)

module Key : sig

  type t =
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

  val of_char : char -> t
  val to_char : t -> char
  val to_shift_char : t -> string
  val to_alpha_char : t -> char
end

module Keyboard : sig
  val scan : unit -> unit
  val key_down : Key.t -> bool
  val wait_key_press : unit -> Key.t
end

(****************************************)
(* Implementation of IO from stdlib     *)
(****************************************)

val print_bytes : bytes -> unit
(** Print a byte sequence on standard output.
   @since 4.02.0 *)

val prerr_bytes : bytes -> unit
(** Print a byte sequence on standard error.
   @since 4.02.0 *)


(** {2 General output functions} *)

type out_channel

type open_flag =
  Open_rdonly      (** open for reading. *)
| Open_wronly      (** open for writing. *)
| Open_append      (** open for appending: always write at end of file. *)
| Open_creat       (** create the file if it does not exist. *)
| Open_trunc       (** empty the file if it already exists. *)
| Open_excl        (** fail if Open_creat and the file already exists. *)
| Open_binary      (** open in binary mode (no conversion). *)
| Open_text        (** open in text mode (may perform conversions). *)
| Open_nonblock    (** open in non-blocking mode. *)
(** Opening modes for {!Pervasives.open_out_gen} and {!Pervasives.open_in_gen}. *)

(* TODO *)

(* val open_out : string -> out_channel *)
(* (\** Open the named file for writing, and return a new output channel *)
(* on that file, positioned at the beginning of the file. The *)
(* file is truncated to zero length if it already exists. It *)
(* is created if it does not already exists. *\) *)

(* val open_out_bin : string -> out_channel *)
(* (\** Same as {!Pervasives.open_out}, but the file is opened in binary mode, *)
(* so that no translation takes place during writes. On operating *)
(* systems that do not distinguish between text mode and binary *)
(* mode, this function behaves like {!Pervasives.open_out}. *\) *)

(* val open_out_gen : open_flag list -> int -> string -> out_channel *)
(* (\** [open_out_gen mode perm filename] opens the named file for writing, *)
(* as described above. The extra argument [mode] *)
(* specifies the opening mode. The extra argument [perm] specifies *)
(* the file permissions, in case the file must be created. *)
(* {!Pervasives.open_out} and {!Pervasives.open_out_bin} are special *)
(* cases of this function. *\) *)

(* val flush : out_channel -> unit *)
(* (\** Flush the buffer associated with the given output channel, *)
(* performing all pending writes on that channel. *)
(* Interactive programs must be careful about flushing standard *)
(* output and standard error at the right time. *\) *)

(* val flush_all : unit -> unit *)
(* (\** Flush all open output channels; ignore errors. *\) *)

(* val output_char : out_channel -> char -> unit *)
(* (\** Write the character on the given output channel. *\) *)

(* val output_string : out_channel -> string -> unit *)
(* (\** Write the string on the given output channel. *\) *)

(* val output_bytes : out_channel -> bytes -> unit *)
(* (\** Write the byte sequence on the given output channel. *)
(* @since 4.02.0 *\) *)

(* val output : out_channel -> bytes -> int -> int -> unit *)
(* (\** [output oc buf pos len] writes [len] characters from byte sequence [buf], *)
(* starting at offset [pos], to the given output channel [oc]. *)
(* Raise [Invalid_argument "output"] if [pos] and [len] do not *)
(* designate a valid range of [buf]. *\) *)

(* val output_substring : out_channel -> string -> int -> int -> unit *)
(* (\** Same as [output] but take a string as argument instead of *)
(* a byte sequence. *)
(* @since 4.02.0 *\) *)

(* val close_out : out_channel -> unit *)
(* (\** Close the given channel, flushing all buffered write operations. *)
(* Output functions raise a [Sys_error] exception when they are *)
(* applied to a closed output channel, except [close_out] and [flush], *)
(* which do nothing when applied to an already closed channel. *)
(* Note that [close_out] may raise [Sys_error] if the operating *)
(* system signals an error when flushing or closing. *\) *)

(* val close_out_noerr : out_channel -> unit *)
(* (\** Same as [close_out], but ignore all errors. *\) *)

(** {2 General input functions} *)

type in_channel

val open_in : string -> in_channel
(** Open the named file for reading, and return a new input channel
   on that file, positioned at the beginning of the file. *)

val input_char : in_channel -> char
(** Read one character from the given input channel.
   Raise [End_of_file] if there are no more characters to read. *)

val input : in_channel -> bytes -> int -> int -> int
(** [input ic buf pos len] reads up to [len] characters from
   the given channel [ic], storing them in byte sequence [buf], starting at
   character number [pos].
   It returns the actual number of characters read, between 0 and
   [len] (inclusive).
   A return value of 0 means that the end of file was reached.
   A return value between 0 and [len] exclusive means that
   not all requested [len] characters were read, either because
   no more characters were available at that time, or because
   the implementation found it convenient to do a partial read;
   [input] must be called again to read the remaining characters,
   if desired.  (See also {!Pervasives.really_input} for reading
   exactly [len] characters.)
   Exception [Invalid_argument "input"] is raised if [pos] and [len]
   do not designate a valid range of [buf]. *)

val close_in : in_channel -> unit
(** Close the given channel.  Input functions raise a [Sys_error]
  exception when they are applied to a closed input channel,
  except [close_in], which does nothing when applied to an already
  closed channel. *)
