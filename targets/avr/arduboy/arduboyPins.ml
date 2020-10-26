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

let bit_of_pin =
  function
  | PIN0 -> B2
  | PIN1 -> B3
  | PIN2 -> B1
  | PIN3 -> B0
  | PIN4 -> B4
  | PIN5 -> B6
  | PIN6 -> B7
  | PIN7 -> B6
  | PIN8 -> B4
  | PIN9 -> B5
  | PIN10 -> B6
  | PIN11 -> B7
  | PIN12 -> B6
  | PIN13 -> B7
  | MISO -> B3
  | SCK -> B1
  | MOSI -> B2
  | SS -> B0
  | PINA0 -> B7
  | PINA1 -> B6
  | PINA2 -> B5
  | PINA3 -> B4
  | PINA4 -> B1
  | PINA5 -> B0

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

external do_pin_change_callback : register -> bit -> (unit -> unit) -> unit = "caml_avr_pin_change_callback"

let pin_change_callback p closure =
  let input = input_of_pin p in
  let bit = bit_of_pin p in
  do_pin_change_callback input bit closure
