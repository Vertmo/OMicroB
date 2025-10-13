let draw_cell x y alive =
  if alive then Screen.fill_rect Color.black (x*10) (y*10) 10 10

class world width height =
  object(self)
    val mutable tcell = Array.make_matrix width height false
    val mutable gen = 0
    method draw() =
      Screen.clear ();
      for i = 0 to (width-1) do
        for j = 0 to (height-1) do
          draw_cell i j tcell.(i).(j)
        done
      done
    method getCell(i,j) = tcell.(i).(j)
    method setCell(i,j,c) = tcell.(i).(j) <- c
    method getCells = tcell

    method neighbors(x,y) =
      let r = ref 0 in
      for i=x-1 to x+1 do
        let k = (i+width) mod width in
        for j=y-1 to y+1 do
          let l = (j + height) mod height in
          if tcell.(k).(l) then incr r
        done
      done;
      if tcell.(x).(y) then decr r ;
      !r

    method copy() =
      let w = new world width height in
      Array.blit tcell 0 w#getCells 0 width;
      w

    method getGen = gen
    method setGen g = gen <- g

    method nextGen() =
      let w2 = new world width height in
      for i=0 to width-1 do
        for j=0 to height -1 do
          let n = self#neighbors(i,j) in
          if tcell.(i).(j)
          then (if (n = 2) || (n = 3) then w2#setCell(i,j,true))
          else (if n = 3 then w2#setCell(i,j,true))
        done
      done ;
      tcell <- w2#getCells ;
      gen <- gen + 1
  end ;;

let width = 32 and height = 24

let draw_cursor cx cy =
  Screen.fill_rect Color.red (cx * 10) (cy * 10) 4 2;
  Screen.fill_rect Color.red (cx * 10) (cy * 10) 2 4;
  Screen.fill_rect Color.red (cx * 10 + 6) (cy * 10) 4 2;
  Screen.fill_rect Color.red (cx * 10 + 8) (cy * 10) 2 4;
  Screen.fill_rect Color.red (cx * 10) (cy * 10 + 8) 4 2;
  Screen.fill_rect Color.red (cx * 10) (cy * 10 + 6) 2 4;
  Screen.fill_rect Color.red (cx * 10 + 6) (cy * 10 + 8) 4 2;
  Screen.fill_rect Color.red (cx * 10 + 8) (cy * 10 + 6) 2 4;;

open Key

let edit w =
  let rec loop cx cy =
    w#draw();
    draw_cursor cx cy;
    Screen.print "Edition" 0 0;
    match Keyboard.wait_key_press () with
    | Key_left -> loop ((cx + width - 1) mod width) cy
    | Key_up -> loop cx ((cy + height - 1) mod height)
    | Key_right -> loop ((cx + 1) mod width) cy
    | Key_down -> loop cx ((cy + 1) mod height)
    | Key_ok -> w#setCell(cx,cy,(not w#getCells.(cx).(cy))); loop cx cy
    | Key_exe -> w
    | _ -> loop cx cy
  in loop (width/2) (height/2);;

exception Fin;;

let rec run w =
  delay 100;
  w#nextGen ();
  w#draw();
  Screen.print ("Gen "^string_of_int w#getGen) 0 0;
  Keyboard.scan ();
  if Keyboard.key_down Key_home then raise Fin
  else if Keyboard.key_down Key_back then () else run w

let () =
  try
    let rec loop w =
      let w = edit w in
      let w' = w#copy () in
      run w;
      loop w'
    in loop (new world width height)
  with Fin -> ()
