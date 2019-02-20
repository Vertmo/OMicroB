(* https://github.com/lancaster-university/microbit-samples/blob/master/source/examples/accelerometer/main.cpp *)
open MicroBit

let pixel_of_g g =
  if g < -750 then 0
  else if g < -250 then 1
  else if g < 250 then 2
  else if g < 750 then 3
  else 4

let _ =
  while true do
    let x = pixel_of_g (Accelerometer.x ())
    and y = pixel_of_g (Accelerometer.y ()) in

    clear_screen ();
    write_pixel x y HIGH;
    delay 10;
  done
