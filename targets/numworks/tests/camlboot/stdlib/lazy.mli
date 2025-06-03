(**
   This module provides a pure OCaml implementation of lazy computations,
   mimicking the functionality of the standard `Lazy` module without relying
   on `CamlinternalLazy` or direct manipulation of OCaml's internal object
   representation.
*)

type 'a t
(** The type of a lazy computation that will eventually produce a value of type ['a]. *)

val from_fun : (unit -> 'a) -> 'a t
(** [from_fun f] creates a lazy computation that, when forced, will evaluate [f ()].
    The function [f] will be evaluated at most once. *)

val from_val : 'a -> 'a t
(** [from_val v] creates a lazy computation that immediately resolves to the value [v].
    Forcing this lazy value will always return [v] without any further computation. *)

val force : 'a t -> 'a
(** [force l] evaluates the lazy computation [l] if it hasn't been evaluated yet,
    and returns its result. If [l] has already been evaluated, its previously
    computed result is returned. If the evaluation of [l] raises an exception,
    that exception is re-raised every time [force l] is called. *)

val is_val : 'a t -> bool
(** [is_val l] returns [true] if the lazy computation [l] has already been evaluated
    (i.e., it holds a value), and [false] otherwise (i.e., it still needs to be forced). *)

exception Undefined
(** Raised when attempting to force a lazy value that is still in the process of
    being computed (e.g., during a recursive force). *)
