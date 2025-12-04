let rec takc (x, y, z) =
  if x > y then takc (takc( (x-1), y, z), (takc( (y-1), z, x)), (takc( (z-1), x, y)))
           else z

let repeat n =
  for i = 0 to n do
    let _ = takc(3,2,1) in ()
  done

let () =
  let start = millis () in
  repeat 200; (* x 1000 to compare with OMicroB *)
  let stop = millis () in
  print_int (stop-start)
