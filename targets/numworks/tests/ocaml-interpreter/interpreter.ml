(* Experimental OCaml interpreter for the Numworks calculator *)

let long_delay = 3000
let exit (code:int) = ()

let filename = "ocaml.py"

let default_program = "
(* Example of an OCaml script to use
   with the OCaml-Numworks app *)
let rec fibonacci n =
  if n <= 1 then
    n
  else
    fibonacci (n-1) + fibonacci (n-2)
in
fibonacci, fibonacci 15;;
"


(* https://stackoverflow.com/questions/55689054/ocamlbuild-with-toploop-toplevel *)
(* An eval function like in Python: takes an OCaml string, evaluate it, print the result, and returns unit *)
let eval code =
  let as_buf = Lexing.from_string code in
  (* let as_buf = Stdlib.Lexing.from_string code in *)
  let parsed = !Toploop.parse_toplevel_phrase as_buf in
  ignore (Toploop.execute_phrase true Format.std_formatter parsed)


let () =
  (* This initialization step has to be done, see the StackOverflow post above. *)
  Toploop.initialize_toplevel_env ();

  (* TODO: when compiling for the Numworks, uncomment these lines. *)
  clear_screen ();
  print_endline ("Loading code from '" ^ filename ^ "' ...");
  let file_content = read_any_file filename in

  (* let file_content = "" in *)
  let file_content = if file_content = "" then default_program else file_content in

  print_endline (
    "Parsing the file content (length " ^ (string_of_int (String.length file_content))^ ")..."
  );
  eval file_content;

  (* Test to check if the previous 'eval file_content' was correct *)
  print_newline ();
  print_endline "If everything went alright,";
  print_endline "the previous line should have been:";
  print_endline "- : (int -> int) * int = (<fun>, 610)";

  print_newline ();
  (* TODO: when compiling for the Numworks, uncomment these lines. *)
  delay long_delay;
  exit 0
