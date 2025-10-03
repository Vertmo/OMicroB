class cell a =
  object
    val mutable v = (a : bool)
    method isAlive = v
  end ;;


(* 4.2 *)

class virtual absWorld n m  =
  object(self)
    val mutable tcell = Array.make_matrix n m (new cell false)
    val maxx = n
    val maxy = m
    val mutable gen = 0
    method private dessine(c) =
     if c#isAlive then print_string "*"
     else print_string "."
    method display() =
      clear_screen ();
      for i = 0 to (maxx-1) do
        for j=0 to (maxy -1) do
          print_string " " ;
          self#dessine(tcell.(i).(j))
        done ;
        print_newline()
      done
    method getCell(i,j) = tcell.(i).(j)
    method setCell(i,j,c) = tcell.(i).(j) <- c
    method getCells = tcell
  end ;;


(* 4.3 *)

class world n m =
  object(self)
    inherit absWorld n m
    method neighbors(x,y) =
      let r = ref 0 in
      for i=x-1 to x+1 do
        let k = (i+maxx) mod maxx in
        for j=y-1 to y+1 do
          let l = (j + maxy) mod maxy in
            if tcell.(k).(l)#isAlive then incr r
        done
      done;
      if tcell.(x).(y)#isAlive then decr r ;
      !r

    method nextGen() =
      let w2 = new world maxx maxy in
      for i=0 to maxx-1 do
        for j=0 to maxy -1 do
          let n = self#neighbors(i,j) in
          if tcell.(i).(j)#isAlive
          then (if (n = 2) || (n = 3) then w2#setCell(i,j,new cell true))
          else (if n = 3 then w2#setCell(i,j,new cell true))
        done
      done ;
      tcell <- w2#getCells ;
      gen <- gen + 1
  end ;;


(* 4.4 *)

exception Fin;;


let read_line () = ""

let main () =

  let a = 10 and b = 12 in
  let w = new world a b in
  w#setCell(0,1,new cell true) ;
  w#setCell(1,2,new cell true) ;
  w#setCell(2,0,new cell true) ;
  w#setCell(2,1,new cell true) ;
  w#setCell(2,2,new cell true) ;
  try
    while true do
      w#display() ;
      match Keyboard.wait_key_press () with
      | Key_home | Key_back -> raise Fin
      | Key_exe -> w#nextGen ()
      | _ -> ()
    done
  with Fin -> () ;;

main () ;;
