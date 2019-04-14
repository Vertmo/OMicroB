module I2C = I2C(struct let address = 0x3C end)
module Scr = Ssd1306.MakeSSD1306(I2C)

type coord = (int * int)
type side = Left | Right

(** Draw or undraw one of the paddles *)
let draw_paddle side y show =
  let x = (match side with Left -> 0 | Right -> 126) in
  for i = y-5 to y+5 do
    Scr.set_pixel x i show; Scr.set_pixel (x+1) i show
  done

(** Draw or undraw the ball *)
let draw_ball (x, y) show =
  for i = x-1 to x+1 do
    for j = y-1 to y+1 do
      Scr.set_pixel i j show
    done
  done

let draw_all bcoord ly ry =
  draw_ball bcoord true;
  draw_paddle Left ly true; draw_paddle Right ry true

let _ =
  Scr.init (); Radio.init ();
  let bcoord = ref (64, 32) in
  let leftY = ref 32 and rightY = ref 32 in
  draw_all !bcoord !leftY !rightY;
  while true do
    (* Receive new position of paddles *)
    let s = Radio.recv () in
    if(String.length s > 0) then (
      if (String.get s 0) = 'l' then (
        let newY = min 58 (max 5 (int_of_string (String.sub s 1 ((String.length s) - 1)))) in
        if newY <> !leftY then (
          draw_paddle Left !leftY false;
          leftY := newY;
          draw_paddle Left !leftY true;
        )
      ) else if (String.get s 0) = 'r' then (
        let newY = min 58 (max 5 (int_of_string (String.sub s 1 ((String.length s) - 1)))) in
        if newY <> !rightY then (
          draw_paddle Right !rightY false;
          rightY := 58 - newY;
          draw_paddle Right !rightY true;
        )
      )
    );
    delay 5
  done
