(* Example of an OCaml script to be used by the OMicroB-camlboot app *)

let rec fibonacci n =
  if n <= 1 then
    n
  else
    fibonacci (n-1) + fibonacci (n-2);;

"Fibonacci of 13 is: ";;
fibonacci 13;;
