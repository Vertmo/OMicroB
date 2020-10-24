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

let port_of_pin =
  function
  | PIN0 -> PORTD
  | PIN1 -> PORTD
  | PIN2 -> PORTD
  | PIN3 -> PORTD
  | PIN4 -> PORTD
  | PIN5 -> PORTC
  | PIN6 -> PORTD
  | PIN7 -> PORTE
  | PIN8 -> PORTB
  | PIN9 -> PORTB
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTD
  | PIN13 -> PORTC
  | MISO -> PORTB
  | SCK -> PORTB
  | MOSI -> PORTB
  | SS -> PORTB
  | PINA0 -> PORTF
  | PINA1 -> PORTF
  | PINA2 -> PORTF
  | PINA3 -> PORTF
  | PINA4 -> PORTF
  | PINA5 -> PORTF

let ddr_of_pin =
  function
  | PIN0 -> DDRD
  | PIN1 -> DDRD
  | PIN2 -> DDRD
  | PIN3 -> DDRD
  | PIN4 -> DDRD
  | PIN5 -> DDRC
  | PIN6 -> DDRD
  | PIN7 -> DDRE
  | PIN8 -> DDRB
  | PIN9 -> DDRB
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRD
  | PIN13 -> DDRC
  | MISO -> DDRB
  | SCK -> DDRB
  | MOSI -> DDRB
  | SS -> DDRB
  | PINA0 -> DDRF
  | PINA1 -> DDRF
  | PINA2 -> DDRF
  | PINA3 -> DDRF
  | PINA4 -> DDRF
  | PINA5 -> DDRF

let input_of_pin =
  function
  | PIN0 -> PIND
  | PIN1 -> PIND
  | PIN2 -> PIND
  | PIN3 -> PIND
  | PIN4 -> PIND
  | PIN5 -> PINC
  | PIN6 -> PIND
  | PIN7 -> PINE
  | PIN8 -> PINB
  | PIN9 -> PINB
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PIND
  | PIN13 -> PINC
  | MISO -> PINB
  | SCK -> PINB
  | MOSI -> PINB
  | SS -> PINB
  | PINA0 -> PINF
  | PINA1 -> PINF
  | PINA2 -> PINF
  | PINA3 -> PINF
  | PINA4 -> PINF
  | PINA5 -> PINF

let port_bit_of_pin =
  function
  | PIN0 -> PD2
  | PIN1 -> PD3
  | PIN2 -> PD1
  | PIN3 -> PD0
  | PIN4 -> PD4
  | PIN5 -> PC6
  | PIN6 -> PD7
  | PIN7 -> PE6
  | PIN8 -> PB4
  | PIN9 -> PB5
  | PIN10 -> PB6
  | PIN11 -> PB7
  | PIN12 -> PD6
  | PIN13 -> PC7
  | MISO -> PB3
  | SCK -> PB1
  | MOSI -> PB2
  | SS -> PB0
  | PINA0 -> PF7
  | PINA1 -> PF6
  | PINA2 -> PF5
  | PINA3 -> PF4
  | PINA4 -> PF1
  | PINA5 -> PF0


let ddr_bit_of_pin =
  function
  | PIN0 -> DD2
  | PIN1 -> DD3
  | PIN2 -> DD1
  | PIN3 -> DD0
  | PIN4 -> DD4
  | PIN5 -> DC6
  | PIN6 -> DD7
  | PIN7 -> DE6
  | PIN8 -> DB4
  | PIN9 -> DB5
  | PIN10 -> DB6
  | PIN11 -> DB7
  | PIN12 -> DD6
  | PIN13 -> DC7
  | MISO -> DB3
  | SCK -> DB1
  | MOSI -> DB2
  | SS -> DB0
  | PINA0 -> DF7
  | PINA1 -> DF6
  | PINA2 -> DF5
  | PINA3 -> DF4
  | PINA4 -> DF1
  | PINA5 -> DF0


let input_bit_of_pin =
  function
  | PIN0 -> ID2
  | PIN1 -> ID3
  | PIN2 -> ID1
  | PIN3 -> ID0
  | PIN4 -> ID4
  | PIN5 -> IC6
  | PIN6 -> ID7
  | PIN7 -> IE6
  | PIN8 -> IB4
  | PIN9 -> IB5
  | PIN10 -> IB6
  | PIN11 -> IB7
  | PIN12 -> ID6
  | PIN13 -> IC7
  | MISO -> IB3
  | SCK -> IB1
  | MOSI -> IB2
  | SS -> IB0
  | PINA0 -> IF7
  | PINA1 -> IF6
  | PINA2 -> IF5
  | PINA3 -> IF4
  | PINA4 -> IF1
  | PINA5 -> IF0

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_read_bit" [@@noalloc]

let pin_mode p m =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  let ddr_bit = ddr_bit_of_pin p in
  let ddr = ddr_of_pin p in
  match m with
  | OUTPUT ->
    set_bit ddr ddr_bit
  | INPUT ->
    clear_bit ddr ddr_bit;
    clear_bit port bit
  | INPUT_PULLUP ->
    clear_bit ddr ddr_bit;
    set_bit port bit

let digital_write p b =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  match b with
  | HIGH -> set_bit port bit
  | LOW -> clear_bit port bit

let digital_read p =
  let input = input_of_pin p in
  let bit = input_bit_of_pin p in
  match read_bit input bit with
  | true -> HIGH
  | false -> LOW
