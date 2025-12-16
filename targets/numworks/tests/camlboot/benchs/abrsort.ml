(* Preamble: missing from stdlib *)

module Random = struct
  external int : int -> int = "caml_random_int"
end

module List = struct
  let rec rev_append l1 l2 =
    match l1 with
    | [] -> l2
    | a::l -> rev_append l (a::l2)
end

(* Code proper *)

type 'a tree = Empty | Node of 'a * 'a tree * 'a tree

let init n f =
  let rec aux n acc =
    if n = 0 then acc
    else
      aux (n-1) ((f n)::acc)
  in
  aux n []

let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l

let rec add a t =
  match t with
    | Empty -> Node (a,Empty, Empty)
    | Node (x,l,r) -> if a < x then Node(x,add a l,r) else Node(x,l,add a r)

let rec to_list t =
  match t with
    | Empty -> []
    | Node (x,l,r) -> List.rev_append (to_list l) (x :: to_list r)

let tree_sort l =
  let t = fold_left (fun acc x -> add x acc) Empty l in
  to_list t

let _ =
  let start = millis () in
  for i = 1 to 10 (* *1000 to compare with OMicroB *) do
    let l = init 30 (fun x -> Random.int x) in
    let _ = tree_sort l in ()
  done;
  let stop = millis () in
  print_int (stop-start)
