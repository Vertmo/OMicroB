open Avr

type register =
  | PORTA
  | PORTB
  | PORTC
  | PORTD
  | PORTE
  | PORTF
  | PORTG
  | PORTH
  | PORTJ
  | PORTK
  | PORTL
  | DDRA
  | DDRB
  | DDRC
  | DDRD
  | DDRE
  | DDRF
  | DDRG
  | DDRH
  | DDRJ
  | DDRK
  | DDRL
  | PINA
  | PINB
  | PINC
  | PIND
  | PINE
  | PINF
  | PING
  | PINH
  | PINJ
  | PINK
  | PINL
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
  | PIN14
  | PIN15
  | PIN16
  | PIN17
  | PIN18
  | PIN19
  | PIN20
  | PIN21
  | PIN22
  | PIN23
  | PIN24
  | PIN25
  | PIN26
  | PIN27
  | PIN28
  | PIN29
  | PIN30
  | PIN31
  | PIN32
  | PIN33
  | PIN34
  | PIN35
  | PIN36
  | PIN37
  | PIN38
  | PIN39
  | PIN40
  | PIN41
  | PIN42
  | PIN43
  | PIN44
  | PIN45
  | PIN46
  | PIN47
  | PIN48
  | PIN49
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
  | PINA6
  | PINA7
  | PINA8
  | PINA9
  | PINA10
  | PINA11
  | PINA12
  | PINA13
  | PINA14
  | PINA15
include AvrPins
  with type register := register
  with type pin := pin

(** SPI slave communication *)
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
