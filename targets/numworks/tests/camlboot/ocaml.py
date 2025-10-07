let () =
  List.iter (fun i -> print_int i; print_string "\n") (List.init 100 (fun x -> x))
