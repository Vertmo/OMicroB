(* Example of an OCaml script to be used by the OMicroB-camlboot app *)

let rec fib n =
  if n <= 1 then
    n
  else
    fib (n-1) + fib (n-2);;
