open Avr

type register =
  | PORTB
  | PORTC
  | PORTD
  | DDRB
  | DDRC
  | DDRD
  | PINB
  | PINC
  | PIND
  | SPCR
  | SPSR
  | SPDR
type pin =
  | PIN0
  | PIN1
  | PIN2
  | PIN3
  | PIN4
  | PIN5
  | PIN6
  | PIN7
  | PIN8
  | PIN9
  | PIN10
  | PIN11
  | PIN12
  | PIN13
  | MISO
  | SCK
  | MOSI
  | SS
  | PINA0
  | PINA1
  | PINA2
  | PINA3
  | PINA4
  | PINA5
include AvrPins
  with type register := register
  with type pin := pin

module SPISlave: Circuits.SPI

module MakeSPIMaster(SC: sig
    type pin
    type level
    type mode
    val high: level
    val low: level
    val output_mode: mode
    val pin_mode: pin -> mode -> unit
    val digital_write: pin -> level -> unit
    val slavePin: pin
  end): Circuits.SPI
