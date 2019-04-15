(** Change the side depending on the side you want to program *)

type side = Left | Right

let string_of_side = function | Left -> "l" | Right -> "r"

let rec loop_choose_side () =
  if ButtonA.is_on () then Left
  else if ButtonB.is_on () then Right
  else (delay 10; loop_choose_side ())

let _ =
  Radio.init ();
  let side = loop_choose_side () in
  let y = ref 32 in
  while true do
    if ButtonA.is_on () then (y := max (!y - 1) 5;
                              Radio.send ((string_of_side side)^(String.make 1 (char_of_int (!y)))));
    if ButtonB.is_on () then (y := min (!y + 1) 58;
                              Radio.send ((string_of_side side)^(String.make 1 (char_of_int (!y)))));
    delay 10
  done
