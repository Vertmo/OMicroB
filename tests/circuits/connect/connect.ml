open Circuits

let%component MyGreenLed = MakeLed(connectedPin = PIN3)
let%component MyRedLed = MakeLed(connectedPin = PIN4)
let%component MyBlueLed = MakeLed(connectedPin = PIN5)

let%component MyButton1 = MakeButton(connectedPin = PIN6)
let%component MyButton2 = MakeButton(connectedPin = PIN7)

let%gate MyOr = Or(MyButton1;MyButton2)
let%gate MyNot = Not(MyOr)

let%multiact MyMultiAct = MultiAct(MyRedLed;MyGreenLed;MyBlueLed)

let%connect MyConnect = Connect(MyOr;MyMultiAct)

let _ =
  MyGreenLed.init (); MyRedLed.init (); MyBlueLed.init ();
  MyButton1.init (); MyButton2.init ();
  while true do
    MyConnect.update ();
    delay 10
  done
