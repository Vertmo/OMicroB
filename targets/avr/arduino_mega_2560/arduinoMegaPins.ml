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

let port_bit_of_pin =
  function
  | PIN0 -> PE0
  | PIN1 -> PE1
  | PIN2 -> PE4
  | PIN3 -> PE5
  | PIN4 -> PG5
  | PIN5 -> PE3
  | PIN6 -> PH3
  | PIN7 -> PH4
  | PIN8 -> PH5
  | PIN9 -> PH6
  | PIN10 -> PB4
  | PIN11 -> PB5
  | PIN12 -> PB6
  | PIN13 -> PB7
  | PIN14 -> PJ1
  | PIN15 -> PJ0
  | PIN16 -> PH1
  | PIN17 -> PH0
  | PIN18 -> PD3
  | PIN19 -> PD2
  | PIN20 -> PD1
  | PIN21 -> PD0
  | PIN22 -> PA0
  | PIN23 -> PA1
  | PIN24 -> PA2
  | PIN25 -> PA3
  | PIN26 -> PA4
  | PIN27 -> PA5
  | PIN28 -> PA6
  | PIN29 -> PA7
  | PIN30 -> PC7
  | PIN31 -> PC6
  | PIN32 -> PC5
  | PIN33 -> PC4
  | PIN34 -> PC3
  | PIN35 -> PC2
  | PIN36 -> PC1
  | PIN37 -> PC0
  | PIN38 -> PD7
  | PIN39 -> PG2
  | PIN40 -> PG1
  | PIN41 -> PG0
  | PIN42 -> PL7
  | PIN43 -> PL6
  | PIN44 -> PL5
  | PIN45 -> PL4
  | PIN46 -> PL3
  | PIN47 -> PL2
  | PIN48 -> PL1
  | PIN49 -> PL0
  | MISO -> PB3
  | SCK -> PB1
  | MOSI -> PB2
  | SS -> PB0
  | PINA0 -> PF0
  | PINA1 -> PF1
  | PINA2 -> PF2
  | PINA3 -> PF3
  | PINA4 -> PF4
  | PINA5 -> PF5
  | PINA6 -> PF6
  | PINA7 -> PF7
  | PINA8 -> PK0
  | PINA9 -> PK1
  | PINA10 -> PK2
  | PINA11 -> PK3
  | PINA12 -> PK4
  | PINA13 -> PK5
  | PINA14 -> PK6
  | PINA15 -> PK7


let ddr_bit_of_pin =
  function
  | PIN0 -> DE0
  | PIN1 -> DE1
  | PIN2 -> DE4
  | PIN3 -> DE5
  | PIN4 -> DG5
  | PIN5 -> DE3
  | PIN6 -> DH3
  | PIN7 -> DH4
  | PIN8 -> DH5
  | PIN9 -> DH6
  | PIN10 -> DB4
  | PIN11 -> DB5
  | PIN12 -> DB6
  | PIN13 -> DB7
  | PIN14 -> DJ1
  | PIN15 -> DJ0
  | PIN16 -> DH1
  | PIN17 -> DH0
  | PIN18 -> DD3
  | PIN19 -> DD2
  | PIN20 -> DD1
  | PIN21 -> DD0
  | PIN22 -> DA0
  | PIN23 -> DA1
  | PIN24 -> DA2
  | PIN25 -> DA3
  | PIN26 -> DA4
  | PIN27 -> DA5
  | PIN28 -> DA6
  | PIN29 -> DA7
  | PIN30 -> DC7
  | PIN31 -> DC6
  | PIN32 -> DC5
  | PIN33 -> DC4
  | PIN34 -> DC3
  | PIN35 -> DC2
  | PIN36 -> DC1
  | PIN37 -> DC0
  | PIN38 -> DD7
  | PIN39 -> DG2
  | PIN40 -> DG1
  | PIN41 -> DG0
  | PIN42 -> DL7
  | PIN43 -> DL6
  | PIN44 -> DL5
  | PIN45 -> DL4
  | PIN46 -> DL3
  | PIN47 -> DL2
  | PIN48 -> DL1
  | PIN49 -> DL0
  | MISO -> DB3
  | SCK -> DB1
  | MOSI -> DB2
  | SS -> DB0
  | PINA0 -> DF0
  | PINA1 -> DF1
  | PINA2 -> DF2
  | PINA3 -> DF3
  | PINA4 -> DF4
  | PINA5 -> DF5
  | PINA6 -> DF6
  | PINA7 -> DF7
  | PINA8 -> DK0
  | PINA9 -> DK1
  | PINA10 -> DK2
  | PINA11 -> DK3
  | PINA12 -> DK4
  | PINA13 -> DK5
  | PINA14 -> DK6
  | PINA15 -> DK7

let input_bit_of_pin =
  function
  | PIN0 -> IE0
  | PIN1 -> IE1
  | PIN2 -> IE4
  | PIN3 -> IE5
  | PIN4 -> IG5
  | PIN5 -> IE3
  | PIN6 -> IH3
  | PIN7 -> IH4
  | PIN8 -> IH5
  | PIN9 -> IH6
  | PIN10 -> IB4
  | PIN11 -> IB5
  | PIN12 -> IB6
  | PIN13 -> IB7
  | PIN14 -> IJ1
  | PIN15 -> IJ0
  | PIN16 -> IH1
  | PIN17 -> IH0
  | PIN18 -> ID3
  | PIN19 -> ID2
  | PIN20 -> ID1
  | PIN21 -> ID0
  | PIN22 -> IA0
  | PIN23 -> IA1
  | PIN24 -> IA2
  | PIN25 -> IA3
  | PIN26 -> IA4
  | PIN27 -> IA5
  | PIN28 -> IA6
  | PIN29 -> IA7
  | PIN30 -> IC7
  | PIN31 -> IC6
  | PIN32 -> IC5
  | PIN33 -> IC4
  | PIN34 -> IC3
  | PIN35 -> IC2
  | PIN36 -> IC1
  | PIN37 -> IC0
  | PIN38 -> ID7
  | PIN39 -> IG2
  | PIN40 -> IG1
  | PIN41 -> IG0
  | PIN42 -> IL7
  | PIN43 -> IL6
  | PIN44 -> IL5
  | PIN45 -> IL4
  | PIN46 -> IL3
  | PIN47 -> IL2
  | PIN48 -> IL1
  | PIN49 -> IL0
  | MISO -> IB3
  | SCK -> IB1
  | MOSI -> IB2
  | SS -> IB0
  | PINA0 -> IF0
  | PINA1 -> IF1
  | PINA2 -> IF2
  | PINA3 -> IF3
  | PINA4 -> IF4
  | PINA5 -> IF5
  | PINA6 -> IF6
  | PINA7 -> IF7
  | PINA8 -> IK0
  | PINA9 -> IK1
  | PINA10 -> IK2
  | PINA11 -> IK3
  | PINA12 -> IK4
  | PINA13 -> IK5
  | PINA14 -> IK6
  | PINA15 -> IK7

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

external do_pin_change_callback : 'a register -> 'a -> (unit -> unit) -> unit = "caml_avr_pin_change_callback"

let pin_change_callback p closure =
  let input = input_of_pin p in
  let bit = input_bit_of_pin p in
  do_pin_change_callback input bit closure
