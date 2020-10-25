module%comp SPIM = MakeSPIMaster(struct let slavePin = PIN5 end)

let _ =
  SPIM.init ();
  while true do
    delay 1000;
    ignore (SPIM.transmit 'm');
  done
