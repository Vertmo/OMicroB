let%component MyDisp = LiquidCrystal.MakeLCD(
    rsPin = PIN9;
    enablePin = PIN8;
    d4Pin = PIN5;
    d5Pin = PIN4;
    d6Pin = PIN3;
    d7Pin = PIN2;
  )

let _ =
  MyDisp.init ();
  SPISlave.init ();
  while true do
    let c = SPISlave.transmit 's' in
    MyDisp.print_string (String.make 1 c)
  done
