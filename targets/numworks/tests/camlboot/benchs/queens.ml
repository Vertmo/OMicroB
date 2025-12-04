let rec interval n m =
    if n > m then [] else n :: interval (n+1) m

let rec (@) l1 l2 =
  match l1 with
  | [] -> l2
  | hd::tl -> hd::(tl @ l2)

let rec concmap f l =
  match l with
  | [] -> []
  | x :: l -> f x @ concmap f l

let rec safe d x l =
  match l with
  | [] -> true
  | q::l -> (not (x = q)) && ((not (x = q+d)) && ((not (x = q-d)) && safe (d+1) x l))

let ok l =
  match l with
  | [] -> true
  | x::l -> safe 1 x l

let rec map f l =
  match l with
  | [] -> []
  | hd::tl -> (f hd)::(map f tl)

let rec filter p l  =
  match l with
  | [] -> []
  | x::l -> if p x then x::filter p l else filter p l

let range = interval 1

let queens n =
  let qs = range n in
  let testcol b = filter ok (map (fun q -> q::b) qs) in
  let rec gen = function
    | 0 -> [[]]
    | n -> concmap testcol (gen (n - 1)) in
  gen n

let () =
  let start = millis () in
  for _i = 1 to 10 do (* x 1000 for comparison to OMicroB *)
    for j = 0 to 6 do
      let _ = queens j in ()
    done
  done;
  let stop = millis () in
  print_int (stop-start)
