let rec integ accu x f  b h =
  if  x >=  b then accu else integ (accu +. (f x)) (x +. h) f  b h
;;

let integrale f a b n =
  let h = (b -. a) /. (float_of_int n) in
  integ  0.0 (a *. h) f  b h 
;;


let poly x = x *. x +. 2. *. x +. 1.
;;

let repeat n =
  for i = 0 to n do
    let _ = integrale poly 0.0 1.0 100 in () (* XXX I changed n, otherwise out of memory *)
  done
;;

(* integrale poly 0.0 1.0 10000 -> 2.333583335 (* 0.333383335 *) *)

let () =
  let start = millis () in
  repeat 4; (* x 1000 for OMicroB *)
  let stop = millis () in
  print_int (stop-start)
