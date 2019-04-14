(*******************************************************************************)
(*                                                                             *)
(*         Port of the Adafruit SSD_1306 library in OCaml (for OMicroB         *)
(*       Original lib : https://github.com/adafruit/Adafruit_SSD1306           *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

module MakeSSD1306(I2C: Circuits.I2C) = struct
  let screen = Bytes.make 1025 (char_of_int 0)

  let command c =
    let b = Bytes.make ((Array.length c) + 1) (char_of_int 0) in
    for i = 1 to (Array.length c) do Bytes.set b i (char_of_int (c.(i-1))) done;
    I2C.write b

  let set_pos col page =
    command [|0xB0 lor page|];
    let c1 = col land 0x0F and c2 = col lsr 4 in
    command [|0x00 lor c1|]; command [|0x10 lor c2|]

  let draw_screen () =
    set_pos 0 0;
    I2C.write screen

  let clear_screen () =
    Bytes.fill screen 1 ((Bytes.length screen) - 1) (char_of_int 0);
    draw_screen ()

  let init () =
    I2C.init ();
    List.iter command [
      [|0xAE|]; (* DISPLAYOFF *)
      [|0xD5; 0x80|]; (* SETDISPLAYCLOCKDIV *)
      [|0xA8|]; (* SETMULTIPLEX *)
      [|63|]; (* height - 1 *)
      [|0xD3; 0x00|]; (* SETDISPLAYOFFSET *)
      [|0x40; 0x0|]; (* SETSTARTLINE *)
      [|0x8D; 0x14|]; (* CHARGEPUMP *)
      [|0x20; 0x00|]; (* MEMORYMODE *)
      [|0x21; 0; 127|];
      [|0x22; 0; 63|];
      [|0xA0 lor 0x1|]; (* SEGREMAP *)
      [|0xC8|]; (* COMSCANDEC *)
      [|0xDA; 0x12|]; (* SETCOMPINS *)
      [|0x81|]; (* SETCONTRAST *)
      [|0xD9; 0xF1|]; (* SETPRECHARGE *)
      [|0xDB; 0x40|]; (* SETVCOMDETECT *)
      [|0xA4|];
      [|0xA6|]; (* DISPLAYALLON_RESUME *)
      [|0x2E|]; (* DEACTIVATE_SCROLL *)
      [|0xAF|] (* DISPLAYON *)
    ];
    Bytes.set screen 0 (char_of_int 0x40);
    clear_screen ()

  let set_pixel x y color =
    let page = y / 8 and shift_p = y mod 8 in
    let ind = (x + page * 128) + 1 in
    let b = if color
      then (int_of_char (Bytes.get screen ind)) lor (1 lsl shift_p)
      else (int_of_char (Bytes.get screen ind)) land (lnot (1 lsl shift_p)) in
    Bytes.set screen ind (char_of_int b);
    set_pos x page;
    let by = Bytes.make 2 (char_of_int 0x40) in
    Bytes.set by 1 (char_of_int b);
    I2C.write by

  let print_image _ = failwith "Not yet implemented"

  let print_newline () = failwith "Not yet implemented"

  let print_string _ = failwith "Not yet implemented"

  let print_int _ = failwith "Not yet implemented"
end
