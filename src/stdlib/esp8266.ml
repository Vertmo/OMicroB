(*******************************************************************************)
(*                                                                             *)
(*                       Esp8266 manipulation library                          *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8 | PINA0
type _pin = pin

type mode = INPUT | OUTPUT | INPUT_PULLUP
type _mode = mode

type level = LOW | HIGH
type _level = level

external pin_mode: pin -> mode -> unit = "caml_esp8266_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_esp8266_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_esp8266_digital_read" [@@noalloc]
external unsafe_analog_write: pin -> int -> unit = "caml_esp8266_analog_write" [@@noalloc]
let analog_write p l =
  if (l < 0 || l >= 1024) then invalid_arg "analog_write: value should be between 0 and 1023";
  unsafe_analog_write p l

external unsafe_analog_read: pin -> int = "caml_esp8266_analog_read" [@@noalloc]
let analog_read p =
  if (p <> PINA0) then invalid_arg "analog_write: only pin A0 is supported";
  unsafe_analog_read p

external delay: int -> unit = "caml_esp8266_delay" [@@noalloc]
external millis: unit -> int = "caml_esp8266_millis" [@@noalloc]


module Serial = struct
  external init: unit -> unit = "caml_esp8266_serial_init" [@@noalloc]

  external write_char: char -> unit = "caml_esp8266_serial_write_char" [@@noalloc]
  let write s = String.iter write_char s

  external read_char: unit -> char = "caml_esp8266_serial_read_char" [@@noalloc]
  let read () =
    let s = ref ""
    and c = ref (read_char ()) in
    while((int_of_char !c) <> 0) do
      s := (!s^(String.make 1 !c));
      c := (read_char ())
    done;
    if(String.length !s > 0) then String.sub !s 0 ((String.length !s)-1) else ""
end

module MCUConnection = struct
  type pin = _pin
  type mode = _mode
  type level = _level
  let low = LOW
  let high = HIGH
  let input_mode = INPUT
  let output_mode = OUTPUT
  let digital_read = digital_read
  let digital_write = digital_write
  let analog_read = analog_read
  let analog_write = analog_write
  let pin_mode = pin_mode
  let delay = delay
  let millis = millis
end
