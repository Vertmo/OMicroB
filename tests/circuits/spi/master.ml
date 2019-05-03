let%component SPIMaster = MakeSPIMaster(slavePin = PIN0)

let _ =
  SPIMaster.init ();
  let c = SPIMaster.transmit 'm' in
  Screen.print_string (String.make 1 c)
