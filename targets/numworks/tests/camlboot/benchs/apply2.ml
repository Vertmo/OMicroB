let double f x = f (f x) ;;
let quad n = double double n ;;
let oct n = quad quad n  ;;
let succ n = n + 1 ;;

let repeat n =
  for i = 0 to n do
    let _ = double (quad succ) n in ()
  done

let () =
  let start = millis () in
  repeat 1000; (* x 1000 to compare with OMicroB *)
  let stop = millis () in
  print_int (stop-start)
