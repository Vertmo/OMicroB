(* Interprète MML pour la Numworks *)

open Mylexing

let long_delay = 1000
let short_delay = 500
let delta_y = 18
let exit (code:int) = ()

let filename = "minicaml.py"

let default_program = "let rec fib (n: int) :int =
  if n <= 2 then
    n
  else
    fib (n-1) + fib (n-2)
in
fib 30"

let report (b,e) =
  let lnum = b.pos_lnum in
  let fc = b.pos_cnum - b.pos_bol + 1 in
  let lc = e.pos_cnum - b.pos_bol + 1 in
  print_endline ("File \"" ^ filename ^ "\", line " ^ (string_of_int lnum) ^ ", characters " ^ (string_of_int fc) ^ "-" ^ (string_of_int lc) ^ ":")

let () =
  clear_screen ();
  print_endline ("Loading code from " ^ filename ^ " ...");

  let file_content = read_any_file filename in
  let file_content = if file_content = "" then default_program else file_content in

  let lb = Mylexing.from_string file_content in
  try
    print_endline "Parsing the file...";

    let prog = Mmlparser.program Mmllexer.token lb in

    let type_of_prog = Typechecker.type_prog prog in
    print_string "Type of the program: ";
    print_string (Mml.typ_to_string type_of_prog);
    print_newline ();

    print_string "Evaluation of the program: ";
    let v = Interpreter.eval_prog prog in
    Interpreter.print_value v;
    print_newline ();
    delay long_delay;
    exit 0
  with
  | Mmllexer.Lexing_error s ->
     report (lexeme_start_p lb, lexeme_end_p lb);
     print_endline ("lexical error: " ^ s);
     exit 1
  | Mmlparser.Error ->
     report (lexeme_start_p lb, lexeme_end_p lb);
     print_endline "syntax error";
     exit 1
  | Typechecker.Type_error s ->
     print_endline ("type error: " ^ s);
     exit 1
  | Out_of_memory ->
    print_endline "Out of memory!"
  | Stack_overflow ->
    print_endline "Stack overflow!"
  | e ->
     (* print_endline ("Anomaly: " ^ (Printexc.to_string e)); *)
     print_endline ("Anomaly: (some exception)");
     exit 2
