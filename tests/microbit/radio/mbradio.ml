let _ =
  Radio.init ();
  while true do
    if ButtonA.is_on () then Radio.send 'a';
    if ButtonB.is_on () then Radio.send 'b';
    if (not (ButtonA.is_on () || ButtonB.is_on ())) then Radio.send '0';

    let c = Radio.recv () in
    if c = 'a' then Screen.set_pixel 0 2 true
    else if c = 'b' then Screen.set_pixel 4 2 true
    else if c = '0' then Screen.clear_screen ();

    delay 10
  done
