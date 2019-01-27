open MicroBit

let _ =
  print_string "OMicroB!";
  (* print_int 42; *)
  print_image [[LOW;HIGH;LOW;HIGH;LOW];
               [LOW;HIGH;LOW;HIGH;LOW];
               [LOW;LOW;LOW;LOW;LOW];
               [LOW;LOW;LOW;LOW;LOW];
               [HIGH;HIGH;HIGH;HIGH;HIGH]];

  while(true) do
    if(a_is_pressed ())
    then (write_pixel 0 3 HIGH; write_pixel 0 4 LOW)
    else (write_pixel 0 3 LOW; write_pixel 0 4 HIGH);
    if(b_is_pressed ())
    then (write_pixel 4 3 HIGH; write_pixel 4 4 LOW)
    else (write_pixel 4 3 LOW; write_pixel 4 4 HIGH)
  done
