let () = clear_screen()

let () =
  let ic = open_in "test.py" in
  (try
     while true do
       let c = input_char ic in print_char c
     done
   with End_of_file -> ());
  print_newline ();
  close_in ic

let () =
  let ic = open_in "test.py" in
  let bytes = Bytes.make 20 'a' in
  let n = input ic bytes 0 10 in
  print_endline (Bytes.to_string bytes);
  let n = input ic bytes 10 10 in
  print_endline (Bytes.to_string bytes);
  let n = input ic bytes 0 20 in
  print_endline (Bytes.to_string bytes);
  let n = input ic bytes 0 20 in
  print_int n; print_newline ();
  print_endline (Bytes.to_string bytes);
  close_in ic

let () =
  try
    ignore (open_in "doesnotexist.py")
  with Not_found -> print_endline "Got an exception as expected"

let () =
  while true do () done
