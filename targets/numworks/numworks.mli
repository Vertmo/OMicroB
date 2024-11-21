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


(***********************************)
(* Functions from the EADK library *)
(***********************************)

val color_black : int
val color_white : int
val color_red : int
val color_green : int
val color_blue : int

val screen_width : int
val screen_height : int

val display_draw_string : string -> int -> int -> unit
val display_draw_string_small : string -> int -> int -> unit
(* val display_draw_string_large : string -> int -> int -> unit *)
(* val display_draw_string_full : string -> int -> int -> bool -> int -> int -> unit (\* FIXME: it can RESET the calculator! I don't know why. Wrong conversion from an OCaml int to a uint16_t? *\) *)

val display_push_rect_uniform : int -> int -> int -> int -> int -> unit
val display_push_allscreen_uniform : int -> unit
val clear_screen : unit -> unit
val clear_black_screen : unit -> unit


(*************)
(* Backlight *)
(*************)

val backlight_set_brightness : int -> unit
val backlight_brightness : unit -> int

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

val cat_any_file : string -> unit
val cat_ocamlpy_file : unit -> unit
val read_any_file : string -> string
val read_ocamlpy_file : unit -> string


(****************************************)
(* Copied content of the stdlib.ml file *)
(****************************************)

(** {1 Input/output}
    Note: all input/output functions can raise [Sys_error] when the system
    calls they invoke fail. *)

type in_channel
(** The type of input channel. *)

type out_channel
(** The type of output channel. *)

val stdin : in_channel
(** The standard input for the process. *)

val stdout : out_channel
(** The standard output for the process. *)

val stderr : out_channel
(** The standard error output for the process. *)

val print_bytes : bytes -> unit
(** Print a byte sequence on standard output.
   @since 4.02.0 *)

val prerr_bytes : bytes -> unit
(** Print a byte sequence on standard error.
   @since 4.02.0 *)


(** {2 General output functions} *)

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
(** Opening modes for {!Pervasives.open_out_gen} and
{!Pervasives.open_in_gen}. *)

val open_out : string -> out_channel
(** Open the named file for writing, and return a new output channel
on that file, positioned at the beginning of the file. The
file is truncated to zero length if it already exists. It
is created if it does not already exists. *)

val open_out_bin : string -> out_channel
(** Same as {!Pervasives.open_out}, but the file is opened in binary mode,
so that no translation takes place during writes. On operating
systems that do not distinguish between text mode and binary
mode, this function behaves like {!Pervasives.open_out}. *)

val open_out_gen : open_flag list -> int -> string -> out_channel
(** [open_out_gen mode perm filename] opens the named file for writing,
as described above. The extra argument [mode]
specifies the opening mode. The extra argument [perm] specifies
the file permissions, in case the file must be created.
{!Pervasives.open_out} and {!Pervasives.open_out_bin} are special
cases of this function. *)

val flush : out_channel -> unit
(** Flush the buffer associated with the given output channel,
performing all pending writes on that channel.
Interactive programs must be careful about flushing standard
output and standard error at the right time. *)

val flush_all : unit -> unit
(** Flush all open output channels; ignore errors. *)

val output_char : out_channel -> char -> unit
(** Write the character on the given output channel. *)

val output_string : out_channel -> string -> unit
(** Write the string on the given output channel. *)

val output_bytes : out_channel -> bytes -> unit
(** Write the byte sequence on the given output channel.
@since 4.02.0 *)

val output : out_channel -> bytes -> int -> int -> unit
(** [output oc buf pos len] writes [len] characters from byte sequence [buf],
starting at offset [pos], to the given output channel [oc].
Raise [Invalid_argument "output"] if [pos] and [len] do not
designate a valid range of [buf]. *)

val output_substring : out_channel -> string -> int -> int -> unit
(** Same as [output] but take a string as argument instead of
a byte sequence.
@since 4.02.0 *)

val output_byte : out_channel -> int -> unit
(** Write one 8-bit integer (as the single character with that code)
on the given output channel. The given integer is taken modulo
256. *)

val output_binary_int : out_channel -> int -> unit
(** Write one integer in binary format (4 bytes, big-endian)
on the given output channel.
The given integer is taken modulo 2{^32}.
The only reliable way to read it back is through the
{!Pervasives.input_binary_int} function. The format is compatible across
all machines for a given version of OCaml. *)

val output_value : out_channel -> 'a -> unit
(** Write the representation of a structured value of any type
to a channel. Circularities and sharing inside the value
are detected and preserved. The object can be read back,
by the function {!Pervasives.input_value}. See the description of module
{!Marshal} for more information. {!Pervasives.output_value} is equivalent
to {!Marshal.to_channel} with an empty list of flags. *)

val seek_out : out_channel -> int -> unit
(** [seek_out chan pos] sets the current writing position to [pos]
for channel [chan]. This works only for regular files. On
files of other kinds (such as terminals, pipes and sockets),
the behavior is unspecified. *)

val pos_out : out_channel -> int
(** Return the current writing position for the given channel.  Does
not work on channels opened with the [Open_append] flag (returns
unspecified results). *)

val out_channel_length : out_channel -> int
(** Return the size (number of characters) of the regular file
on which the given channel is opened.  If the channel is opened
on a file that is not a regular file, the result is meaningless. *)

val close_out : out_channel -> unit
(** Close the given channel, flushing all buffered write operations.
Output functions raise a [Sys_error] exception when they are
applied to a closed output channel, except [close_out] and [flush],
which do nothing when applied to an already closed channel.
Note that [close_out] may raise [Sys_error] if the operating
system signals an error when flushing or closing. *)

val close_out_noerr : out_channel -> unit
(** Same as [close_out], but ignore all errors. *)

val set_binary_mode_out : out_channel -> bool -> unit
(** [set_binary_mode_out oc true] sets the channel [oc] to binary
mode: no translations take place during output.
[set_binary_mode_out oc false] sets the channel [oc] to text
mode: depending on the operating system, some translations
may take place during output.  For instance, under Windows,
end-of-lines will be translated from [\n] to [\r\n].
This function has no effect under operating systems that
do not distinguish between text mode and binary mode. *)


(** {2 General input functions} *)

val open_in : string -> in_channel
(** Open the named file for reading, and return a new input channel
   on that file, positioned at the beginning of the file. *)

val open_in_bin : string -> in_channel
(** Same as {!Pervasives.open_in}, but the file is opened in binary mode,
   so that no translation takes place during reads. On operating
   systems that do not distinguish between text mode and binary
   mode, this function behaves like {!Pervasives.open_in}. *)

val open_in_gen : open_flag list -> int -> string -> in_channel
(** [open_in_gen mode perm filename] opens the named file for reading,
   as described above. The extra arguments
   [mode] and [perm] specify the opening mode and file permissions.
   {!Pervasives.open_in} and {!Pervasives.open_in_bin} are special
   cases of this function. *)

val input_char : in_channel -> char
(** Read one character from the given input channel.
   Raise [End_of_file] if there are no more characters to read. *)

val input_line : in_channel -> string
(** Read characters from the given input channel, until a
   newline character is encountered. Return the string of
   all characters read, without the newline character at the end.
   Raise [End_of_file] if the end of the file is reached
   at the beginning of line. *)

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

val input_value : in_channel -> 'a
(** Read the representation of a structured value, as produced
   by {!Pervasives.output_value}, and return the corresponding value.
   This function is identical to {!Marshal.from_channel};
   see the description of module {!Marshal} for more information,
   in particular concerning the lack of type safety. *)

val really_input : in_channel -> bytes -> int -> int -> unit
(** [really_input ic buf pos len] reads [len] characters from channel [ic],
   storing them in byte sequence [buf], starting at character number [pos].
   Raise [End_of_file] if the end of file is reached before [len]
   characters have been read.
   Raise [Invalid_argument "really_input"] if
   [pos] and [len] do not designate a valid range of [buf]. *)

val really_input_string : in_channel -> int -> string
(** [really_input_string ic len] reads [len] characters from channel [ic]
   and returns them in a new string.
   Raise [End_of_file] if the end of file is reached before [len]
   characters have been read.
   @since 4.02.0 *)

val close_in : in_channel -> unit
(** Close the given channel.  Input functions raise a [Sys_error]
  exception when they are applied to a closed input channel,
  except [close_in], which does nothing when applied to an already
  closed channel. *)

val input_byte : in_channel -> int
(** Same as {!Pervasives.input_char}, but return the 8-bit integer representing
   the character.
   Raise [End_of_file] if an end of file was reached. *)

val input_binary_int : in_channel -> int
(** Read an integer encoded in binary format (4 bytes, big-endian)
   from the given input channel. See {!Pervasives.output_binary_int}.
   Raise [End_of_file] if an end of file was reached while reading the
   integer. *)

val input_value : in_channel -> 'a
(** Read the representation of a structured value, as produced
   by {!Pervasives.output_value}, and return the corresponding value.
   This function is identical to {!Marshal.from_channel};
   see the description of module {!Marshal} for more information,
   in particular concerning the lack of type safety. *)

val seek_in : in_channel -> int -> unit
(** [seek_in chan pos] sets the current reading position to [pos]
   for channel [chan]. This works only for regular files. On
   files of other kinds, the behavior is unspecified. *)

val pos_in : in_channel -> int
(** Return the current reading position for the given channel. *)

val in_channel_length : in_channel -> int
(** Return the size (number of characters) of the regular file
    on which the given channel is opened.  If the channel is opened
    on a file that is not a regular file, the result is meaningless.
    The returned size does not take into account the end-of-line
    translations that can be performed when reading from a channel
    opened in text mode. *)

