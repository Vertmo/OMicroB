(*******************************************************************************)
(*                                                                             *)
(*                       Esp8266 manipulation library                          *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type pin = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | D8 | A0

(** Pin modes *)
type mode = INPUT | OUTPUT | INPUT_PULLUP

(** Read and write levels (HIGH = 5v, LOW = 0v) *)
type level = LOW | HIGH

external pin_mode: pin -> mode -> unit = "caml_esp8266_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_esp8266_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_esp8266_digital_read" [@@noalloc]

external delay: int -> unit = "caml_esp8266_delay" [@@noalloc]