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

let port_of_pin =
  function
  | PIN0 -> PORTD
  | PIN1 -> PORTD
  | PIN2 -> PORTD
  | PIN3 -> PORTD
  | PIN4 -> PORTD
  | PIN5 -> PORTD
  | PIN6 -> PORTD
  | PIN7 -> PORTD
  | PIN8 -> PORTB
  | PIN9 -> PORTB
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTB
  | PIN13 -> PORTB
  | MISO -> PORTB
  | SCK -> PORTB
  | MOSI -> PORTB
  | SS -> PORTB
  | PINA0 -> PORTC
  | PINA1 -> PORTC
  | PINA2 -> PORTC
  | PINA3 -> PORTC
  | PINA4 -> PORTC
  | PINA5 -> PORTC

let ddr_of_pin =
  function
  | PIN0 -> DDRD
  | PIN1 -> DDRD
  | PIN2 -> DDRD
  | PIN3 -> DDRD
  | PIN4 -> DDRD
  | PIN5 -> DDRD
  | PIN6 -> DDRD
  | PIN7 -> DDRD
  | PIN8 -> DDRB
  | PIN9 -> DDRB
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRB
  | PIN13 -> DDRB
  | MISO -> DDRB
  | SCK -> DDRB
  | MOSI -> DDRB
  | SS -> DDRB
  | PINA0 -> DDRC
  | PINA1 -> DDRC
  | PINA2 -> DDRC
  | PINA3 -> DDRC
  | PINA4 -> DDRC
  | PINA5 -> DDRC

let input_of_pin =
  function
  | PIN0 -> PIND
  | PIN1 -> PIND
  | PIN2 -> PIND
  | PIN3 -> PIND
  | PIN4 -> PIND
  | PIN5 -> PIND
  | PIN6 -> PIND
  | PIN7 -> PIND
  | PIN8 -> PINB
  | PIN9 -> PINB
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PINB
  | PIN13 -> PINB
  | MISO -> PINB
  | SCK -> PINB
  | MOSI -> PINB
  | SS -> PINB
  | PINA0 -> PINC
  | PINA1 -> PINC
  | PINA2 -> PINC
  | PINA3 -> PINC
  | PINA4 -> PINC
  | PINA5 -> PINC

let bit_of_pin =
  function
  | PIN0 -> B0
  | PIN1 -> B1
  | PIN2 -> B2
  | PIN3 -> B3
  | PIN4 -> B4
  | PIN5 -> B5
  | PIN6 -> B6
  | PIN7 -> B7
  | PIN8 -> B0
  | PIN9 -> B1
  | PIN10 -> B2
  | PIN11 -> B3
  | PIN12 -> B4
  | PIN13 -> B5
  | MISO -> B4
  | SCK -> B5
  | MOSI -> B3
  | SS -> B0
  | PINA0 -> B0
  | PINA1 -> B1
  | PINA2 -> B2
  | PINA3 -> B3
  | PINA4 -> B4
  | PINA5 -> B5

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_read_bit" [@@noalloc]

let pin_mode p m =
  let port = port_of_pin p in
  let ddr = ddr_of_pin p in
  let bit = bit_of_pin p in
  match m with
  | OUTPUT ->
    set_bit ddr bit
  | INPUT ->
    clear_bit ddr bit;
    clear_bit port bit
  | INPUT_PULLUP ->
    clear_bit ddr bit;
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

module SPISlave = struct
  external init: unit -> unit = "caml_avr_spi_init_slave" [@@noalloc]
  external transmit: char -> char = "caml_avr_spi_transmit" [@@noalloc]
end

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
  end) = struct

  external master_init: unit -> unit = "caml_avr_spi_init_master" [@@noalloc]

  let init () =
    SC.pin_mode SC.slavePin SC.output_mode;
    SC.digital_write SC.slavePin SC.high;
    master_init ();

  external master_transmit: char -> char = "caml_avr_spi_transmit" [@@noalloc]

  let transmit c =
    SC.digital_write SC.slavePin SC.low;
    let r = master_transmit c in
    SC.digital_write SC.slavePin SC.high;
    r
end
