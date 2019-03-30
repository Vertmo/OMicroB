let%component MyLightSensor = Circuits.MakeAnalogSensor(connectedPin = PINA0)
let%component MyLed = Circuits.MakeLed(connectedPin = PIN3)

let _ =
  Serial.init ();
  MyLightSensor.init (); MyLed.init ();
  while true do
    let l = MyLightSensor.level () in
    if l > 100 then MyLed.on () else MyLed.off ();
    Serial.write (string_of_int (MyLightSensor.level()));
    Serial.write "\n";
    delay 200
  done
