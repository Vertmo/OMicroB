(**
hello.ml: example of some tiny OCaml code to be compiled to an NWA app for the Numworks
Simply install OMicroB with this line from the main OMicroB directory:
$ make clean && ./configure -target numworks && make
Then run in this tests/hello_world/ directory
$ make
Then flash the hello.nwa app to your Numworks calculator, using <https://my.numworks.com/apps> !
*)

let test_cat_read_files () =
  (* WOOW reading and displaying the content of a file (from C) worked! *)
  print_endline "cat_ocamlpy_file...";
  let _ = cat_ocamlpy_file () in
  print_endline "cat_ocamlpy_file done";
  delay 3000;
  clear_screen();

  (* DONE: read from C and return a OCaml string *)
  print_endline "read_ocamlpy_file...\r\n";
  let content_of_ocamlpy_file : string = read_ocamlpy_file () in
  print_endline "read_ocamlpy_file done\r\n";
  delay 5000;

  display_push_allscreen_uniform color_blue;
  print_endline content_of_ocamlpy_file;
  delay 10000;

  (* display_push_allscreen_uniform color_blue; *)
  (* display_draw_string_small (String.make 50 'X') 0 0; *)
  (* delay 10000; *)
;;

(* test_cat_read_files ();; *)

(* Examples of OCaml basic recursive code, to test the limit of the stack-size and heap-size *)
let rec fact n =
  if n <= 1 then 1
  else n * fact(n-1)
;;

let rec fibonacci_rec n =
  if n <= 1 then n
  else fibonacci_rec (n-1) + fibonacci_rec (n-2)
;;


(** TODO: document this main() test function. *)
let main () =
  delay 1000; clear_screen ();
  print_endline "Starting main() tests...";
  print_endline "In 1 secs";

  (* Dynamically generated strings works fine too *)
  delay 1000; clear_screen ();
  print_endline (String.make 100 'X');

  assert(true);
  (* this should fail ! what happens for an assert(false) on the Numworks ? *)
  (* assert(120 < 100); *)
  (* FIXME: this prints "Error!" continuously... not very useful... *)

  (* delay_usec 1_000_000; clear_screen (); *)
  (* print_endline "After a delay_usec 1_000_000"; *)

  (* delay 1000; clear_screen (); *)
  (* print_endline "backlight_brightness():"; *)
  (* print_int (backlight_brightness()); *)

  (* delay 1000; clear_screen (); *)
  (* print_endline "backlight_set_brightness(0):"; *)
  (* delay 500; *)
  (* backlight_set_brightness(0); *)
  (* delay 500; *)
  (* print_endline "backlight_set_brightness(100):"; *)
  (* backlight_set_brightness(100); *)
  (* delay 500; *)

  (* delay 1000; clear_screen ();
  print_endline "battery_is_charging():";
  print_bool (battery_is_charging()); *)

  (* delay 1000; clear_screen ();
  print_endline "battery_level():";
  print_int (battery_level()); *)

  (* delay 1000; clear_screen ();
  print_endline "battery_voltage():";
  print_float (battery_voltage()); *)

  (* delay 1000; clear_screen ();
  print_endline "usb_is_plugged():";
  print_bool (usb_is_plugged()); *)

  for _ = 1 to 5 do
    delay 1000; clear_screen ();
    print_string "random(): ";
    print_int (random());
    print_newline ()
  done;

  delay 1000; clear_screen ();
  print_endline "print_endline():";

  delay 1000; clear_screen ();
  print_string "print_int 42: ";
  print_int 42;
  print_newline ();

  delay 1000; clear_screen ();
  print_string "print_float 3.1415: ";
  print_float 3.1415;
  print_newline ();

  delay 1000; clear_screen ();
  print_string "print_char '?': ";
  print_char '?';
  print_newline ();

  delay 1000; clear_screen ();
  print_string "millis():";
  print_int (millis ());
  print_newline ();
  delay 3000; clear_screen ();
  print_string "After delay(3000)";
  print_int (millis ());
  print_newline ();

  delay 1000; clear_screen ();
  print_endline "Loop #1.";
  let nb_loop = 3 in
  for _ = 1 to nb_loop do
    print_endline "Hello from OCaml VM";
    delay 100;
    print_endline "Running on Numworks?";
    delay 100;
  print_endline "Compiled thanks to OMicroB !";
  done;
  print_endline "End loop #1.";

  delay 1000; clear_screen ();
  print_endline "Loop #2.";
  let max_n = 21 in
  for n = 0 to max_n do
    print_string "fact "; print_int n; print_string " = "; print_int (fact n);
    print_newline();
    delay 100;
  done;
  print_endline "End loop #2.";
  delay 1000;

  delay 1000; clear_screen ();
  print_endline "Loop #3.";
  (* FIXME: fibonacci_rec fails VERY quickly, I guess the stack size for recursive function is VERY LIMITED?
     The STACK_SIZE parameter in the Makefile allows now to change this parameter, to increase it.
  *)
  let max_n = 10 in
  for n = 0 to max_n do
    print_string "fibonacci_rec "; print_int n; print_string " = "; print_int (fibonacci_rec n);
    print_newline();
    delay 100;
  done;
  print_endline "End loop #3.";

  delay 1000; clear_screen ();
  print_endline "Loop #4.";
  let delta_y = 18 in
  for i = 1 to 12 do
    let x = i and y = delta_y * i in
    let text = "draw at {" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ "}" in
    display_draw_string text x y ;
    delay 250;
  done;
  delay 250;
  print_endline "End loop #4.";

  delay 1000; clear_screen ();
  print_endline "Loop #5.";
  let small_delta_y = 10 in
  for i = 1 to 23 do
    let x = i and y = small_delta_y * i in
    let text = "draw small at {" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ "}" in
    display_draw_string_small text x y ;
    delay 250;
  done;
  delay 250;
  print_endline "End loop #5.";

  (* FIXME: this test breaks my calculator, it makes it RESET completely! *)
  (* let array_colors = [| color_black; color_white; color_red; color_green; color_blue |] in *)
  (* let array_name_colors = [| "black"; "white"; "red"; "green"; "blue" |] in *)
  (* let nb_colors = Array.length array_colors in *)

  (* for color1 = 0 to nb_colors-1 do *)
  (*   for color2 = 0 to nb_colors-1 do *)
  (*     for i = 1 to 12 do *)
  (*       let x = 0 and y = delta_y * i in *)
  (*       let text = "draw " ^ (array_name_colors.(color1)) ^"/" ^ (array_name_colors.(color2)) ^ " at {" ^ (string_of_int x) ^ "," ^ (string_of_int y) ^ "}" in *)
  (*       print_endline text; *)
  (*       delay 1000; *)
  (*       (\* FIXME: this test breaks my calculator, it makes it RESET completely! *\) *)
  (*       (\* display_draw_string text x y true array_colors.(color1) array_colors.(color2) ; *\) *)
  (*       delay 1000; *)
  (*     done; *)
  (*     delay 2000; *)
  (*   done; *)
  (*   delay 200; *)
  (* done; *)

  delay 1000; clear_screen ();
  print_endline "Done for all the tests.";
  delay 1000;
;;

main ();;
