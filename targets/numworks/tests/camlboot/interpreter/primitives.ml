open Data
open Runtime_lib
open Runtime_base
open Runtime_stdlib
open Runtime_compiler

let prims =
  let prim1 f = prim1 f Runtime_base.wrap_exn in
  [ ( "%field1",
      ptr @@ Prim
        (onptr @@ function
        | Tuple l -> List.hd (List.tl l)
        | _ -> assert false) );
    (* Array *)
    ( "caml_array_concat",
      prim1 Array.concat (unwrap_list unwrap_array_id) wrap_array_id );
  ]

let prims =
  List.fold_left (fun env (name, v) -> SMap.add name v env) SMap.empty prims

let () =
  Runtime_compiler.apply_ref := Eval.apply prims
