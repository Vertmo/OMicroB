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

(** Weak array operations; in OMicroB, weak pointers always fail :) *)

type 'a t = int

let create i = i
let set p _ _ = ()
let get _ _ = None
