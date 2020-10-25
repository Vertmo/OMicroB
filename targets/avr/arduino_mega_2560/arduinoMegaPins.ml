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

let port_of_pin =
  function
  | PIN0 -> PORTE
  | PIN1 -> PORTE
  | PIN2 -> PORTE
  | PIN3 -> PORTE
  | PIN4 -> PORTG
  | PIN5 -> PORTE
  | PIN6 -> PORTH
  | PIN7 -> PORTH
  | PIN8 -> PORTH
  | PIN9 -> PORTH
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTB
  | PIN13 -> PORTB
  | PIN14 -> PORTJ
  | PIN15 -> PORTJ
  | PIN16 -> PORTH
  | PIN17 -> PORTH
  | PIN18 -> PORTD
  | PIN19 -> PORTD
  | PIN20 -> PORTD
  | PIN21 -> PORTD
  | PIN22 -> PORTA
  | PIN23 -> PORTA
  | PIN24 -> PORTA
  | PIN25 -> PORTA
  | PIN26 -> PORTA
  | PIN27 -> PORTA
  | PIN28 -> PORTA
  | PIN29 -> PORTA
  | PIN30 -> PORTC
  | PIN31 -> PORTC
  | PIN32 -> PORTC
  | PIN33 -> PORTC
  | PIN34 -> PORTC
  | PIN35 -> PORTC
  | PIN36 -> PORTC
  | PIN37 -> PORTC
  | PIN38 -> PORTD
  | PIN39 -> PORTG
  | PIN40 -> PORTG
  | PIN41 -> PORTG
  | PIN42 -> PORTL
  | PIN43 -> PORTL
  | PIN44 -> PORTL
  | PIN45 -> PORTL
  | PIN46 -> PORTL
  | PIN47 -> PORTL
  | PIN48 -> PORTL
  | PIN49 -> PORTL
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
  | PINA6 -> PORTF
  | PINA7 -> PORTF
  | PINA8 -> PORTK
  | PINA9 -> PORTK
  | PINA10 -> PORTK
  | PINA11 -> PORTK
  | PINA12 -> PORTK
  | PINA13 -> PORTK
  | PINA14 -> PORTK
  | PINA15 -> PORTK

let ddr_of_pin =
  function
  | PIN0 -> DDRE
  | PIN1 -> DDRE
  | PIN2 -> DDRE
  | PIN3 -> DDRE
  | PIN4 -> DDRG
  | PIN5 -> DDRE
  | PIN6 -> DDRH
  | PIN7 -> DDRH
  | PIN8 -> DDRH
  | PIN9 -> DDRH
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRB
  | PIN13 -> DDRB
  | PIN14 -> DDRJ
  | PIN15 -> DDRJ
  | PIN16 -> DDRH
  | PIN17 -> DDRH
  | PIN18 -> DDRD
  | PIN19 -> DDRD
  | PIN20 -> DDRD
  | PIN21 -> DDRD
  | PIN22 -> DDRA
  | PIN23 -> DDRA
  | PIN24 -> DDRA
  | PIN25 -> DDRA
  | PIN26 -> DDRA
  | PIN27 -> DDRA
  | PIN28 -> DDRA
  | PIN29 -> DDRA
  | PIN30 -> DDRC
  | PIN31 -> DDRC
  | PIN32 -> DDRC
  | PIN33 -> DDRC
  | PIN34 -> DDRC
  | PIN35 -> DDRC
  | PIN36 -> DDRC
  | PIN37 -> DDRC
  | PIN38 -> DDRD
  | PIN39 -> DDRG
  | PIN40 -> DDRG
  | PIN41 -> DDRG
  | PIN42 -> DDRL
  | PIN43 -> DDRL
  | PIN44 -> DDRL
  | PIN45 -> DDRL
  | PIN46 -> DDRL
  | PIN47 -> DDRL
  | PIN48 -> DDRL
  | PIN49 -> DDRL
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
  | PINA6 -> DDRF
  | PINA7 -> DDRF
  | PINA8 -> DDRK
  | PINA9 -> DDRK
  | PINA10 -> DDRK
  | PINA11 -> DDRK
  | PINA12 -> DDRK
  | PINA13 -> DDRK
  | PINA14 -> DDRK
  | PINA15 -> DDRK

let input_of_pin =
  function
  | PIN0 -> PINE
  | PIN1 -> PINE
  | PIN2 -> PINE
  | PIN3 -> PINE
  | PIN4 -> PING
  | PIN5 -> PINE
  | PIN6 -> PINH
  | PIN7 -> PINH
  | PIN8 -> PINH
  | PIN9 -> PINH
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PINB
  | PIN13 -> PINB
  | PIN14 -> PINJ
  | PIN15 -> PINJ
  | PIN16 -> PINH
  | PIN17 -> PINH
  | PIN18 -> PIND
  | PIN19 -> PIND
  | PIN20 -> PIND
  | PIN21 -> PIND
  | PIN22 -> PINA
  | PIN23 -> PINA
  | PIN24 -> PINA
  | PIN25 -> PINA
  | PIN26 -> PINA
  | PIN27 -> PINA
  | PIN28 -> PINA
  | PIN29 -> PINA
  | PIN30 -> PINC
  | PIN31 -> PINC
  | PIN32 -> PINC
  | PIN33 -> PINC
  | PIN34 -> PINC
  | PIN35 -> PINC
  | PIN36 -> PINC
  | PIN37 -> PINC
  | PIN38 -> PIND
  | PIN39 -> PING
  | PIN40 -> PING
  | PIN41 -> PING
  | PIN42 -> PINL
  | PIN43 -> PINL
  | PIN44 -> PINL
  | PIN45 -> PINL
  | PIN46 -> PINL
  | PIN47 -> PINL
  | PIN48 -> PINL
  | PIN49 -> PINL
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
  | PINA6 -> PINF
  | PINA7 -> PINF
  | PINA8 -> PINK
  | PINA9 -> PINK
  | PINA10 -> PINK
  | PINA11 -> PINK
  | PINA12 -> PINK
  | PINA13 -> PINK
  | PINA14 -> PINK
  | PINA15 -> PINK

let bit_of_pin =
  function
  | PIN0 -> B0
  | PIN1 -> B1
  | PIN2 -> B4
  | PIN3 -> B5
  | PIN4 -> B5
  | PIN5 -> B3
  | PIN6 -> B3
  | PIN7 -> B4
  | PIN8 -> B5
  | PIN9 -> B6
  | PIN10 -> B4
  | PIN11 -> B5
  | PIN12 -> B6
  | PIN13 -> B7
  | PIN14 -> B1
  | PIN15 -> B0
  | PIN16 -> B1
  | PIN17 -> B0
  | PIN18 -> B3
  | PIN19 -> B2
  | PIN20 -> B1
  | PIN21 -> B0
  | PIN22 -> B0
  | PIN23 -> B1
  | PIN24 -> B2
  | PIN25 -> B3
  | PIN26 -> B4
  | PIN27 -> B5
  | PIN28 -> B6
  | PIN29 -> B7
  | PIN30 -> B7
  | PIN31 -> B6
  | PIN32 -> B5
  | PIN33 -> B4
  | PIN34 -> B3
  | PIN35 -> B2
  | PIN36 -> B1
  | PIN37 -> B0
  | PIN38 -> B7
  | PIN39 -> B2
  | PIN40 -> B1
  | PIN41 -> B0
  | PIN42 -> B7
  | PIN43 -> B6
  | PIN44 -> B5
  | PIN45 -> B4
  | PIN46 -> B3
  | PIN47 -> B2
  | PIN48 -> B1
  | PIN49 -> B0
  | MISO -> B3
  | SCK -> B1
  | MOSI -> B2
  | SS -> B0
  | PINA0 -> B0
  | PINA1 -> B1
  | PINA2 -> B2
  | PINA3 -> B3
  | PINA4 -> B4
  | PINA5 -> B5
  | PINA6 -> B6
  | PINA7 -> B7
  | PINA8 -> B0
  | PINA9 -> B1
  | PINA10 -> B2
  | PINA11 -> B3
  | PINA12 -> B4
  | PINA13 -> B5
  | PINA14 -> B6
  | PINA15 -> B7

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_read_bit" [@@noalloc]

let pin_mode p m =
  let port = port_of_pin p in
  let bit = bit_of_pin p in
  let ddr_bit = bit_of_pin p in
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
  let bit = bit_of_pin p in
  match b with
  | HIGH -> set_bit port bit
  | LOW -> clear_bit port bit

let digital_read p =
  let input = input_of_pin p in
  let bit = bit_of_pin p in
  match read_bit input bit with
  | true -> HIGH
  | false -> LOW

type _pin = pin
type _level = level
type _mode = mode
module MCUConnection = struct
  type pin = _pin
  type level = _level
  type mode = _mode
  let high = HIGH
  let low = LOW
  let input_mode = INPUT
  let output_mode = OUTPUT
  let pin_mode = pin_mode
  let digital_write = digital_write
  let digital_read = digital_read
  let analog_write _ _ = failwith "TODO"
  let analog_read _ = failwith "TODO"
  let millis = Avr.millis
  let delay = Avr.delay
end
