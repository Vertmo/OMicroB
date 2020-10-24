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
  module MCUConnection : Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end

val delay : int -> unit
val millis : unit -> int

module Serial : sig
  val init : unit -> unit
  val read : unit -> char
  val write : char -> unit
  val write_string : string -> unit
  val write_int : int -> unit
end
