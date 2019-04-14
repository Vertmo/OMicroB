(** Change the side depending on the side you want to program *)

type side = Left | Right

let string_of_side = function | Left -> "l" | Right -> "r"

let rec loop_choose_side () =
  if ButtonA.is_on () then Left
  else if ButtonB.is_on () then Right
  else (delay 10; loop_choose_side ())

let paddle_y_of_acc y =
  if(y < 0) then 25-(int_of_float (float_of_int (y+180) /. 180. *. 64.))
  else (int_of_float (float_of_int (180-y) /. 180. *. 64.)+32)

let _ =
  Radio.init ();
  let side = loop_choose_side () in
  while true do
    Radio.send ((string_of_side side)^(String.make 1 (char_of_int (paddle_y_of_acc (Accelerometer.roll ())))));
    delay 5
  done
