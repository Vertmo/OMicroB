let button = PIN9

module%comp MyDisp = Circuits.MakeLCD(struct
    let rsPin = PIN12
    let enablePin = PIN11
    let d4Pin = PIN5
    let d5Pin = PIN4
    let d6Pin = PIN3
    let d7Pin = PIN2
  end)

let _ =
  pin_mode button INPUT;
  MyDisp.init ();
  pin_change_callback button
    (fun () ->
       match (digital_read button) with
       | HIGH -> MyDisp.print_string "Hello VMIL !"
       | LOW -> MyDisp.clear_screen ()
    );
