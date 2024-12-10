(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Damien Doligez, projet Para, INRIA Rocquencourt            *)
(*                                                                        *)
(*   Copyright 1997 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(** Arrays of weak pointers and hash sets of weak pointers. *)


(** {1 Low-level functions} *)

type 'a t
(** The type of arrays of weak pointers (weak arrays).  A weak
   pointer is a value that the garbage collector may erase whenever
   the value is not used any more (through normal pointers) by the
   program.  Note that finalisation functions are run after the
   weak pointers are erased.

   A weak pointer is said to be full if it points to a value,
   empty if the value was erased by the GC.

   Notes:
   - Integers are not allocated and cannot be stored in weak arrays.
   - Weak arrays cannot be marshaled using {!Pervasives.output_value}
     nor the functions of the {!Marshal} module.
*)


val create : int -> 'a t
(** [Weak.create n] returns a new weak array of length [n].
   All the pointers are initially empty.  Raise [Invalid_argument]
   if [n] is negative or greater than {!Sys.max_array_length}[-1].*)

val set : 'a t -> int -> 'a option -> unit
(** [Weak.set ar n (Some el)] sets the [n]th cell of [ar] to be a
   (full) pointer to [el]; [Weak.set ar n None] sets the [n]th
   cell of [ar] to empty.
   Raise [Invalid_argument "Weak.set"] if [n] is not in the range
   0 to {!Weak.length}[ a - 1].*)

val get : 'a t -> int -> 'a option
(** [Weak.get ar n] returns None if the [n]th cell of [ar] is
   empty, [Some x] (where [x] is the value) if it is full.
   Raise [Invalid_argument "Weak.get"] if [n] is not in the range
   0 to {!Weak.length}[ a - 1].*)
