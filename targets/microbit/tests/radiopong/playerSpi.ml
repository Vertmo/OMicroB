(** Change the side depending on the side you want to program *)

module%comp ButtonA = Circuits.MakeButton(struct let connectedPin = PIN7 end)
module%comp ButtonB = Circuits.MakeButton(struct let connectedPin = PIN6 end)

module%comp Screen = Circuits.MakeLCD(struct
    let rsPin = PIN12
    let enablePin = PIN11
    let d4Pin = PIN5
    let d5Pin = PIN4
    let d6Pin = PIN3
    let d7Pin = PIN2
  end)

let _ =
  Screen.init (); SPISlave.init ();
  ButtonA.init (); ButtonB.init ();
  let y = ref 32 in
  let lastScore = ref 0 in
  Screen.print_int !lastScore;
  while true do
    let score = int_of_char (SPISlave.transmit (char_of_int !y)) in
    if score > !lastScore then (
        lastScore := score;
        Screen.clear_screen ();
        Screen.print_int !lastScore
      );
    if ButtonA.is_on () then y := max (!y - 4) 5;
    if ButtonB.is_on () then y := min (!y + 4) 58;
    delay 5
  done
