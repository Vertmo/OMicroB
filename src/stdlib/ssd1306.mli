(*******************************************************************************)
(*                                                                             *)
(*         Port of the Adafruit SSD_1306 library in OCaml (for OMicroB         *)
(*       Original lib : https://github.com/adafruit/Adafruit_SSD1306           *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

(** Make a SSD1306 module *)
module MakeSSD1306(I2C: Circuits.I2C): Circuits.Display
