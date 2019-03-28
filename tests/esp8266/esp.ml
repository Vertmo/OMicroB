(* let _ =
 *   pin_mode D1 OUTPUT;
 *   while true do
 *     digital_write D1 HIGH;
 *     delay 1000;
 *     digital_write D1 LOW;
 *     delay 1000;
 *   done *)

  (* while true do
   *   let _ = serial_read () in
   *   serial_write (string_of_int (millis ()));
   *   delay 1000
   * done *)

  let rgb_of_hsv (h, s, v) =
    let c = v *. s in let m = v -. c in
    let x = c *. (1. -. abs_float ((mod_float (h/.60.) 2.) -. 1.)) in
    let (r', g', b') =
      if h < 60. then (c, x, 0.)
      else if h < 120. then (x, c, 0.)
      else if h < 180. then (0., c, x)
      else if h < 240. then (0., x, c)
      else if h < 300. then (x, 0., c)
      else (c, 0., x) in
    (int_of_float ((r'+.m)*.255.), int_of_float ((g'+.m)*.255.), int_of_float ((b'+.m)*.255.))

let _ =
  let r = D0 and g = D1 and b = D2 in
  while(true) do
    for h = 0 to 360 do
      let (rv, gv, bv) = rgb_of_hsv ((float_of_int h), 1., 1.) in
      analog_write r rv; analog_write g gv; analog_write b bv;
      delay 10
    done
  done
