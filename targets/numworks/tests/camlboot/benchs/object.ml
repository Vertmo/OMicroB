class point x y = object
  val x = x
  val y = y
  method sym = (new point (-x) (-y))
end

let _ =
  let start = millis () in
  for _ = 1 to 100 do (* x 1000 to compare with OMicroB *)
        let o = new point 10 10 in
        for _ = 1 to 10 do
          let _ = o#sym in ()
        done
  done;
  let stop = millis () in
  print_int (stop-start)
