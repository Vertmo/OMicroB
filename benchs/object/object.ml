
class point x y = object
  val x = x
  val y = y
  method sym = (new point (-x) (-y))
end

let _ =
  (* Serial.write_string "Hi ?"; *)
  (* Screen.set_pixel 2 2 true; *)
  clear_screen ();
  let start = millis () in
  for _ = 1 to 1000 do
    for _ = 1 to 10 do
      for _ = 1 to 10 do
        let o = new point (Random.int 100) (Random.int 100) in
        for _ = 1 to 10 do
          ignore(o#sym)
        done
      done
    done
  done;
  let stop = millis () in
  (* Screen.set_pixel 2 3 true; *)
  (* Serial.write_string (string_of_int (stop-start)) *)
  print_int (stop-start); print_newline ();
  while true do () done
