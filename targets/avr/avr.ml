(*******************************************************************************)
(*                                                                             *)
(*                  Generic avr pin communication library                      *)
(*                                                                             *)
(*******************************************************************************)

type level = HIGH | LOW
type mode = INPUT | OUTPUT | INPUT_PULLUP
type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7

type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin

module type AvrPins = sig
  type pin
  type register
  val port_of_pin: pin -> register
  val ddr_of_pin: pin -> register
  val input_of_pin: pin -> register
  val bit_of_pin : pin -> bit
  val pin_mode : pin -> mode -> unit
  val digital_write : pin -> level -> unit
  val digital_read : pin -> level
  val write_register : register -> int -> unit
  val read_register : register -> int
  val set_bit : register -> bit -> unit
  val clear_bit : register -> bit -> unit
  val read_bit : register -> bit -> bool
  val pin_change_callback: pin -> (unit -> unit) -> unit
  module MCUConnection : Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end

external delay : int -> unit = "caml_delay" [@@noalloc]
external millis : unit -> int = "caml_millis" [@@noalloc]

module Serial = struct
  external init: unit -> unit = "caml_avr_serial_init" [@@noalloc]
  external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
  external write : char -> unit = "caml_avr_serial_write" [@@noalloc]

  let write_string s =
    String.iter write s

  let write_int n =
    write_string (string_of_int n)
end

(*****************************************************************************)

external timer_set_period: int -> int -> unit = "caml_avr_timer_set_period" [@@noalloc]

external timer_set_callback: int -> (unit -> unit) -> unit = "caml_avr_timer_set_callback" [@@noalloc]

module type Timer = sig
  val set_period : int -> unit
  val set_callback : (unit -> unit) -> unit
end

module Timer0 = struct
  let set_period p = timer_set_period 0 p
  let set_callback c = timer_set_callback 0 c
end

module Timer2 = struct
  let set_period p = timer_set_period 2 p
  let set_callback c = timer_set_callback 2 c
end

(*****************************************************************************)
