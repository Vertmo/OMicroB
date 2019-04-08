(* Adapted from https://medium.com/@lhartikk/a-blockchain-in-200-lines-of-code-963cc1cc0e54 *)

open Chain
open Communication

let rec loop chain =
  delay 50;

  (* Treat an eventual new command *)
  let s = recv_new_command () in
  (match s with
  | Some (c, s) -> (match c with
      | NewBlock -> (trace s(* let (_, _, _, d, _) = block_of_buf s in Screen.print_string d *)) (* TODO pb avec les string contenant \0 *)
      | Block -> () (* TODO *)
      | SendChain -> () (* TODO *)
      | SendPred -> ()) (* TODO *)
  | None -> ());

  (* Create an eventual new block and loop again *)
  if ButtonA.is_on () && ButtonB.is_on () then (
    Screen.print_string "ab";
    let b = create_block (List.hd chain) "ab" in
    send_new_block b;
    loop (b::chain)
  )
  else if ButtonA.is_on () then (
    Screen.print_string "a";
    let b = create_block (List.hd chain) "a" in
    trace (buf_of_block b);
    loop (b::chain)
  )
  else if ButtonB.is_on () then (
    Screen.print_string "b";
    let b = create_block (List.hd chain) "b" in
    send_new_block b;
    loop (b::chain)
  )
  else loop chain

let _ =
  Radio.init ();
  try
    loop [create_genesis_block ()]
  with Out_of_memory -> Screen.print_string "mem"
