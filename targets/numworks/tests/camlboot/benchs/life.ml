(* Preamble: stuff that's missing from Stdlib *)

external ref : 'a -> 'a ref = "%makemutable"
external (!) : 'a ref -> 'a = "%field0"
external (:=) : 'a ref -> 'a -> unit = "%setfield0"

module Array = struct
  type 'a t
  external make_matrix : int -> int -> 'a -> 'a t t = "caml_array_make_matrix"
  external get : 'a t -> int -> 'a = "%array_safe_get"
  external set : 'a t -> int -> 'a -> unit = "%array_safe_set"
end

external delay : int -> unit = "omicrob_delay"

module Keyboard = struct
  external wait_key_press : unit -> int = "numworks_keyboard_wait_key_press"
  external scan : unit -> unit = "numworks_keyboard_scan"
  external key_down : int -> bool = "numworks_keyboard_key_down"
end

module Color = struct
  type t = int

  let make r g b =
    (r lsl 11) + ((2 * g) lsl 5) + b

  let black : int = make 0 0 0
  let red : int = make 31 0 0
end

module Screen = struct
  external clear : unit -> unit = "numworks_screen_clear"
  external print : string -> int -> int -> unit = "numworks_screen_print"
  external fill_rect : Color.t -> int -> int -> int -> int -> unit = "numworks_screen_fill_rect"
end

(* Now onto the code *)

(* Shift drawing *)
let fill_rect c x y w h = Screen.fill_rect c x (y + 10) w h

let draw_cell x y alive =
  if alive then fill_rect Color.black (x*10) (y*10) 10 10

type world = {
    width: int;
    height: int;
    tcell: bool Array.t Array.t;
  }

let mk_world width height = {
    width = width;
    height = height;
    tcell = Array.make_matrix width height false;
  }

let get_cell w x y = w.tcell.(x).(y)
let set_cell w x y b = w.tcell.(x).(y) <- b

let draw w =
  Screen.clear ();
  for i = 0 to w.width-1 do
    for j = 0 to w.height-1 do
      draw_cell i j (get_cell w i j)
    done
  done

let int_of_bool b = if b then 1 else 0


let next_gen w =
  (* Copy the world *)
  let wcp = Array.make_matrix w.width w.height false in
  for i = 0 to w.width-1 do
    for j = 0 to w.height-1 do
      wcp.(i).(j) <- w.tcell.(i).(j)
    done
  done;
  (* Update the world *)
  let add_cell i j =
    let k = (i+w.width) mod w.width
    and l = (j+w.height) mod w.height in
    int_of_bool wcp.(k).(l)
  in
  let neighbors x y =
    add_cell (x-1) (y+1) + add_cell x (y+1) + add_cell (x+1) (y+1)
    + add_cell (x-1) (y) +  add_cell (x+1) (y)
    + add_cell (x-1) (y-1) + add_cell x (y-1) + add_cell (x+1) (y-1)
  in
  for i=0 to w.width-1 do
    for j=0 to w.height-1 do
      let n = neighbors i j in
      if wcp.(i).(j)
      then set_cell w i j ((n = 2) || (n = 3)) (* staying alive *)
      else set_cell w i j (n = 3) (* being born *)
    done
  done

let width = 5 and height = 5

let draw_cursor cx cy =
  let open Color in
  fill_rect red (cx * 10) (cy * 10) 4 2;
  fill_rect red (cx * 10) (cy * 10) 2 4;
  fill_rect red (cx * 10 + 6) (cy * 10) 4 2;
  fill_rect red (cx * 10 + 8) (cy * 10) 2 4;
  fill_rect red (cx * 10) (cy * 10 + 8) 4 2;
  fill_rect red (cx * 10) (cy * 10 + 6) 2 4;
  fill_rect red (cx * 10 + 6) (cy * 10 + 8) 4 2;
  fill_rect red (cx * 10 + 8) (cy * 10 + 6) 2 4

exception Fin;;

let edit w =
  try
    let x = ref (width/2) and y = ref (height/2) in
    while true do
      draw w;
      draw_cursor !x !y;
      Screen.print "Edition\n" 0 0;
      match Keyboard.wait_key_press () with
      | 0 (* left *) -> x := (!x + width - 1) mod width
      | 1 (* up *) -> y := (!y + height - 1) mod height
      | 2 (* down *) -> y := (!y + 1) mod height
      | 3 (* right *) -> x := (!x + 1) mod width
      | 4 (* ok *) -> set_cell w !x !y (not (get_cell w !x !y))
      | 45 (* exe *) -> raise Fin
      | _ -> ()
    done
  with Fin -> ();;

let rec run w =
  while true do
    delay 100;
    next_gen w;
    draw w;
    Screen.print "Running\n" 0 0;
    Keyboard.scan ();
    if Keyboard.key_down 5 (* back *) then raise Fin
  done

let () =
  try
    while true do
      let w = mk_world width height in
      edit w;
      run w
    done
  with Fin -> ()
