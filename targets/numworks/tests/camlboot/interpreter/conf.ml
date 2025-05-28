let bool_of_env ~default var =
  (* match Sys.getenv_opt var with *)
  (* | Some ("1" | "true" | "yes") -> true *)
  (* | Some ("0" | "false" | "no") -> false *)
  (* | Some other -> *)
  (*   Printf.kprintf *)
  (*     failwith *)
  (*     "Error: unknown %s value %S, use 'true' or 'false'" *)
  (*     var *)
  (*     other *)
  (* | None -> *)
    default

let trace = bool_of_env ~default:false "OCAMLINTERP_TRACE"
let traceend = bool_of_env ~default:false "OCAMLINTERP_TRACE_END"
let tracearg_from = 75000_000000L
let tracecur = ref 0L
let tracedepth = ref 0

let debug = bool_of_env ~default:false "OCAMLINTERP_DEBUG"

let stdlib_path () =
  (* match Sys.getenv_opt "OCAMLINTERP_STDLIB_PATH" with *)
  (* | Some path -> path *)
  (* | None -> *)
    failwith "Error: standard library location must be specified"

let compiler_source_path () =
  (* match Sys.getenv_opt "OCAMLINTERP_SRC_PATH" with *)
  (* | Some path -> path *)
  (* | None -> *)
    failwith
      "Error: please set an OCAMLINTERP_SRC_PATH variable pointing to a \
       checkout of the OCaml compiler distribution sources"

type command =
| Ocamlc
| Ocamlopt
| Files

let command () =
  (* match Sys.getenv_opt "OCAMLINTERP_COMMAND" with *)
  (*   | Some "ocamlc" -> Some Ocamlc *)
  (*   | Some "ocamlopt" -> Some Ocamlopt *)
  (*   | Some "files" -> Some Files *)
  (*   | Some cmd -> *)
  (*      Format.eprintf "Unexpected OCAMLINTERP_COMMAND command %S, \ *)
  (*                      expected ocamlc|ocamlopt|files.@." *)
  (*       cmd; exit 1 *)
  (*   | None -> *) None
