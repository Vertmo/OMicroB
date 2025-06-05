(* Example of an OCaml script to be used by the OMicroB-camlboot app *)

(* open Standardlib;; *)

let rec fibonacci n =
  if n <= 1 then
    n
  else
    fibonacci (n-1) + fibonacci (n-2)
in
(* XXX: Output by the real OCaml's interpreter: *)
(* - : string * (int -> int) * int = ("A Fibonacci function", <fun>, 10946) *)
"A Fibonacci function", fibonacci, fibonacci 5;;
(* XXX: Output by the OCamlBoot's interpreter: *)
(* ("A Fibonacci function", <function>, 10946) *)

(* print_endline "Fibonacci of 21 is: ";; *)
(* print_int (fibonacci 21);; *)
(* print_newline ();; *)
