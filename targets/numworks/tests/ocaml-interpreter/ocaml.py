(* Example of an OCaml script to be used by the OCaml-Numworks app *)
let rec fibonacci n =
  if n <= 1 then
    n
  else
    fibonacci (n-1) + fibonacci (n-2)
in
(* - : string * (int -> int) * int = ("A Fibonaci function", <fun>, 610) *)
"A Fibonacci function", fibonacci, fibonacci 15;;
