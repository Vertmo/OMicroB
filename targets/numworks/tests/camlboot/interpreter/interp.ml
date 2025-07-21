open Data
open Conf
open Eval
open Envir

let parse filename =
  let inc = try open_in filename with e ->
    begin
      (* Printf.eprintf "Error opening file: %s@." filename; *)
      print_string "Error opening file: ";
      print_string filename;
      raise e
    end
  in
  let lexbuf = Lexing.from_channel inc in
  Location.init lexbuf filename;
(*  let parsed = Parser.implementation Lexer.real_token lexbuf in *)
  let parsed = Parse.implementation lexbuf in
  close_in inc;
  parsed

let parse_ml_or_mlpy filename =
  try
    parse filename
  with e1 ->
    parse (filename ^ ".py")

let parse_from_string ?(filename="<string>") code =
  (* FIXME: this was simply to debug and check that both standardlib.ml and ocaml.py file were read *)
  (* print_endline "filename ="; *)
  (* print_endline filename; *)
  (* print_endline "code ="; *)
  (* print_endline code; *)
  (* now we do the lexing and parsing *)
  let lexbuf = Lexing.from_string code in
  Location.init lexbuf filename;
  let parsed = Parse.implementation lexbuf in
  parsed

let default_filename = "ocaml.py"

let default_program = "\
(* Example of an OCaml script to use\
   with the OMicroB-camlboot app *)\
let rec fibonacci n =\
  if n <= 1 then\
    n\
  else\
    fibonacci (n-1) + fibonacci (n-2)\
in\
\"default program\", fibonacci, fibonacci 15;;\
"

let parse_from_numworks_localstorage filename =
  let file_content =
    try
      read_any_file filename
    with e1 ->
      ""
  in
  let file_content = if file_content = "" then default_program else file_content in
  parse_from_string ~filename:filename file_content

(** Previous content of the interp.ml file *)
type env_flag = Open of Longident.t

let stdlib_flag = [Open (Longident.Lident "Standardlib")]
let no_stdlib_flag = []

let stdlib_units =
  let stdlib_path = stdlib_path () in
  let fullpath file = Filename.concat stdlib_path file in
  (no_stdlib_flag, fullpath "standardlib.ml")
  (* (no_stdlib_flag, "stdlib") *)  (* FIXME: the real name should be "stdlib", not "standardlib" *)
  ::
  List.map (fun file -> stdlib_flag, fullpath file) [
  (*
    "sys.ml";
    (* "callback.ml"; *)
    (* "complex.ml"; *)
    (* "float.ml"; *)
    (* "char.ml"; *)
    "bytes.ml";
    "string.ml";
    (* "bytesLabels.ml"; *)
    (* "stringLabels.ml"; *)
    (* "seq.ml"; *)
    "list.ml";
    (* "listLabels.ml"; *)
    (* "set.ml"; *)
    (* "map.ml"; *)
    (* "uchar.ml"; *)
    (* "buffer.ml"; *)
    (* "stream.ml"; *)
    (* "genlex.ml"; *)
    (* "camlinternalFormatBasics.ml"; *)
    (* "camlinternalFormat.ml"; *)
    (* "printf.ml"; *)
    (* "scanf.ml"; *)
    (* "format.ml"; *)
    (* "obj.ml"; *)
    (* "gc.ml"; *)
    (* "camlinternalOO.ml"; *)
    (* "oo.ml"; *)
    (* "camlinternalLazy.ml"; *)
    (* "lazy.ml"; *)
    (* "printexc.ml"; *)
    "array.ml";
    (* "arrayLabels.ml"; *)
    (* "sort.ml"; *)
    "queue.ml";
    (* "int64.ml"; *)
    (* "int32.ml"; *)
    "nativeint.ml";
    (* "digest.ml"; *)
    "random.ml";
    "hashtbl.ml";
    (* "lexing.ml"; *)
    (* "parsing.ml"; *)
    (* "weak.ml"; *)
    (* "ephemeron.ml"; *)
    (* "spacetime.ml"; *)
    "stack.ml";
    (* "arg.ml"; *)
    (* "filename.ml"; *)
    (* "marshal.ml"; *)
    (* "bigarray.ml"; *)
    (* "moreLabels.ml"; *)
    (* "stdLabels.ml"; *)
  *)
  ]

let eval_env_flag ~loc env flag =
  match flag with
  | Open module_ident ->
     let module_ident = Location.mkloc module_ident loc in
     env_extend false env (env_get_module_data env module_ident)

let debug = true
(* let debug = false *)

let load_rec_units env flags_and_units =
  let unit_paths = List.map snd flags_and_units in
  let env = List.fold_left declare_unit env unit_paths in
  List.fold_left
    (fun global_env (flags, unit_path) ->
      let module_name = module_name_of_unit_path unit_path in
      if debug then begin
        (* Printf.eprintf "Loading %s from %s (or %s.py) @." module_name unit_path unit_path; *)
        print_endline ("Loading " ^ module_name ^ " from " ^ unit_path ^ " (or " ^ unit_path ^ ".py)");
      end;
      let module_contents =
        let loc = Location.in_file unit_path in
        let local_env = List.fold_left (eval_env_flag ~loc) global_env flags in
        (* eval_structure Primitives.prims local_env (parse unit_path) *)
        try
          eval_structure Primitives.prims local_env (parse_from_numworks_localstorage unit_path)
        with e1 ->
          print_endline "\nparse_from_numworks failed: trying parse_ml_or_mlpy";
          eval_structure Primitives.prims local_env (parse_ml_or_mlpy unit_path)
      in
      define_unit global_env unit_path (make_module_data module_contents))
    env
    flags_and_units

let stdlib_env =
  let env = Runtime_base.initial_env in
  let env = load_rec_units env stdlib_units in
  env

let run_files () =
  let rev_files = ref [default_filename] in
  let anon_fun file = rev_files := file :: !rev_files in
  (* Arg.parse [] anon_fun ""; *)
  let files = List.rev !rev_files in
  files
  |> List.map (fun file -> stdlib_flag, file)
  |> load_rec_units stdlib_env
  |> ignore

let () =
  try
    run_files ()
  with InternalException e ->
    (* Printf.eprintf "Code raised exception: %a@." pp_print_value e *)
    print_endline ("Code raised internal exception: " ^ (string_of_value e) )
