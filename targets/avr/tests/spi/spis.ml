let _ =
  let led = PIN3 in
  pin_mode led OUTPUT;
  SPISlave.init ();
  while true do
    digital_write led HIGH;
    ignore (SPISlave.transmit 's');
    digital_write led LOW;
    ignore (SPISlave.transmit 's')
  done
