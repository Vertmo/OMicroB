(*******************************************************************************)
(*                                                                             *)
(*                           Microbit library                                  *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type level = LOW | HIGH

type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8 | PIN9 | PIN10
         | PIN11 | PIN12 | PIN13 | PIN14 | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20

module ButtonA: Circuits.Button

module ButtonB: Circuits.Button

external digital_write: pin -> level -> unit = "caml_microbit_digital_write" [@@noalloc]

val digital_read: pin -> level

val analog_write: pin -> int -> unit

val analog_read: pin -> int

external delay: int -> unit = "caml_microbit_delay" [@@noalloc]

external millis: unit -> int = "caml_microbit_millis" [@@noalloc]

module Screen: Circuits.Display

module Serial: sig
  val init: unit -> unit
  val write: string -> unit
  val read: unit -> string
end

module Accelerometer: sig
  val x: unit -> int
  (** Returns the x acceleration in milli-gs *)

  val y: unit -> int
  (** Returns the y acceleration in milli-gs *)

  val z: unit -> int
  (** Returns the z acceleration in milli-gs *)

  val pitch: unit -> int
  (** Returns the pitch, in degrees *)

  val roll: unit -> int
  (** Returns the roll, in degrees *)
end

module Compass: sig
  val calibrate: unit -> unit
  (** Calibrate the compass *)

  val heading: unit -> int
  (** Heading of the device relative to magnetic north (in degrees) *)
end

(** Radio communication *)
module Radio: sig
  val init: unit -> unit
  val send: string -> unit
  val recv: unit -> string
end

module MCUConnection: Circuits.MCUConnection with type pin = pin with type level = level

(** I2C communication for the micro:bit *)
module I2C(A: sig val address: int end): Circuits.I2C