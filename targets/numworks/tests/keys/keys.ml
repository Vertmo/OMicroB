let rec loop1 () =
  Keyboard.scan ();
  if Keyboard.key_down (Key.of_char 'a') then print_string "a" else loop1 ()

let rec loop2 () =
  let key = Keyboard.wait_key_press () in
  (try print_char (Key.to_alpha_char key) with _ -> ());
  if key = Key_home || key = Key_back then () else loop2 ()

let () =
  Screen.clear ();
  print_endline "Press A to advance";
  loop1 ();
  Screen.clear ();
  loop2 ()
