(**
   This module provides a pure OCaml implementation of lazy computations,
   mimicking the functionality of the standard `Lazy` module without relying
   on `CamlinternalLazy` or direct manipulation of OCaml's internal object
   representation.
*)

(* We use a mutable record to store the state of the lazy computation:
   - `Unevaluated` with the function to compute the value.
   - `Evaluated` with the computed value.
   - `Computing` to detect and prevent infinite recursion during evaluation.
*)
type 'a t = { mutable state : 'a lazy_state }

and 'a lazy_state =
  | Unevaluated of (unit -> 'a)
  | Evaluated of 'a
  | Computing

exception Undefined
(* = Stdlib.Lazy.Undefined *)
(* Re-use the standard Undefined exception *)

let from_fun (f : unit -> 'a) : 'a t =
  { state = Unevaluated f }

let from_val (v : 'a) : 'a t =
  { state = Evaluated v }

let force (l : 'a t) : 'a =
  match l.state with
  | Evaluated v ->
      v
  | Unevaluated f ->
      (* Mark as computing to detect recursive forces *)
      l.state <- Computing;
      begin try
        let v = f () in
        l.state <- Evaluated v;
        v
      with e ->
        (* If an exception occurs, store it so it's re-raised on subsequent forces *)
        l.state <- Unevaluated (fun () -> raise e); (* Or a dedicated `Failed` state *)
        raise e
      end
  | Computing ->
      (* This indicates a cyclic or recursive definition being forced *)
      raise Undefined

let is_val (l : 'a t) : bool =
  match l.state with
  | Evaluated _ -> true
  | Unevaluated _
  | Computing -> false

(* Aliases for compatibility, though not strictly necessary in a pure implementation *)
let lazy_from_fun = from_fun
let lazy_from_val = from_val
let lazy_is_val = is_val