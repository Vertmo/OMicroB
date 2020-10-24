open Avr

type register =
    PORTB
  | PORTC
  | PORTD
  | PORTE
  | PORTF
  | DDRB
  | DDRC
  | DDRD
  | DDRE
  | DDRF
  | PINB
  | PINC
  | PIND
  | PINE
  | PINF
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
