let rec loop1 () =
  Keyboard.scan ();
  if Keyboard.key_down (key_of_char 'a') then print_string "a" else loop1 ()

let rec loop2 () =
  let key = Keyboard.wait_key_press () in
  (try print_char (alpha_char_of_key key) with _ -> ());
  if key = Key_home || key = Key_back then () else loop2 ()

let () =
  Screen.clear ();
  print_endline "Press A to advance";
  loop1 ();
  Screen.clear ();
  loop2 ()
