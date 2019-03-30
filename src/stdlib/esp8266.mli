(*******************************************************************************)
(*                                                                             *)
(*                       Esp8266 manipulation library                          *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8 | PINA0

(** Pin modes *)
type mode = INPUT | OUTPUT | INPUT_PULLUP

(** Read and write levels (HIGH = 5v, LOW = 0v) *)
type level = LOW | HIGH

external pin_mode: pin -> mode -> unit = "caml_esp8266_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_esp8266_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_esp8266_digital_read" [@@noalloc]
val analog_write: pin -> int -> unit
val analog_read: pin -> int

external delay: int -> unit = "caml_esp8266_delay" [@@noalloc]
external millis: unit -> int = "caml_esp8266_millis" [@@noalloc]

module Serial: sig
  val init: unit -> unit
  val write: string -> unit
  val read: unit -> string
end

module MCUConnection: Circuits.MCUConnection with type pin = pin with type mode = mode with type level = level
