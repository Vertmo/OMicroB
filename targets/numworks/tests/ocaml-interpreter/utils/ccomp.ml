(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(* Compiling C files and building C libraries *)

let command cmdline =
  if !Clflags.verbose then begin
    prerr_string "+ ";
    prerr_string cmdline;
    prerr_newline()
  end;
  Sys.command cmdline

let run_command cmdline = ignore(command cmdline)

(* Build @responsefile to work around Windows limitations on
   command-line length *)
let build_diversion lst =
  let (responsefile, oc) = Filename.open_temp_file "camlresp" "" in
  List.iter (fun f -> Printf.fprintf oc "%s\n" f) lst;
  close_out oc;
  (* at_exit (fun () -> Misc.remove_file responsefile); *)
  "@" ^ responsefile

let quote_files lst =
  let lst = List.filter (fun f -> f <> "") lst in
  let quoted = List.map Filename.quote lst in
  let s = String.concat " " quoted in
  if String.length s >= 4096 && Sys.os_type = "Win32"
  then build_diversion quoted
  else s

let quote_prefixed pr lst =
  let lst = List.filter (fun f -> f <> "") lst in
  let lst = List.map (fun f -> pr ^ f) lst in
  quote_files lst

let quote_optfile = function
  | None -> ""
  | Some f -> Filename.quote f

let display_msvc_output file name =
  let c = open_in file in
  try
    let first = input_line c in
    if first <> Filename.basename name then
      print_string first;
    while true do
      print_string (input_line c)
    done
  with _ ->
    close_in c;
    Sys.remove file

let compile_file ?output ?(opt="") name =
  let (pipe, file) =
    if Config.ccomp_type = "msvc" && not !Clflags.verbose then
      try
        let (t, c) = Filename.open_temp_file "msvc" "stdout" in
        close_out c;
        (Printf.sprintf " > %s" (Filename.quote t), t)
      with _ ->
        ("", "")
    else
      ("", "") in
  let exit =
    command
      (Printf.sprintf
         "%s %s %s -c %s %s %s %s %s%s"
         (match !Clflags.c_compiler with
          | Some cc -> cc
          | None ->
              let (cflags, cppflags) =
                  if !Clflags.native_code
                  then (Config.ocamlopt_cflags, Config.ocamlopt_cppflags)
                  else (Config.ocamlc_cflags, Config.ocamlc_cppflags) in
              (String.concat " " [Config.c_compiler; cflags; cppflags]))
         (match output with
          | None -> ""
          | Some o -> Printf.sprintf "%s%s" Config.c_output_obj o)
         opt
         (if !Clflags.debug && Config.ccomp_type <> "msvc" then "-g" else "")
         (String.concat " " (List.rev !Clflags.all_ccopts))
         (quote_prefixed "-I" (List.rev !Clflags.include_dirs))
         (Clflags.std_include_flag "-I")
         (Filename.quote name)
         (* cl tediously includes the name of the C file as the first thing it
            outputs (in fairness, the tedious thing is that there's no switch to
            disable this behaviour). In the absence of the Unix module, use
            a temporary file to filter the output (cannot pipe the output to a
            filter because this removes the exit status of cl, which is wanted.
          *)
         pipe) in
  if pipe <> ""
  then display_msvc_output file name;
  exit
