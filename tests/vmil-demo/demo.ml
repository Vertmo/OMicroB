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
  pin_change_callback button
    (fun () ->
       MyDisp.print_string "Hello VMIL !";
       delay 10000;
       MyDisp.clear_screen ()
    );
