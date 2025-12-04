let rec fibo n =
  if n <= 1 then n
  else (fibo (n-1) + fibo (n-2));;

let repeat n =
  for i = 0 to n do
    let _ = fibo 5 in ()
  done

let _ =
  let start = millis () in
  repeat 1000; (* x 1000 to compare with OMicroB *)
  let stop = millis () in
  print_int (stop-start)
