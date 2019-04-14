(* Adapted from https://medium.com/@lhartikk/a-blockchain-in-200-lines-of-code-963cc1cc0e54 *)

open Chain
open Communication

let rec loop chain =
  delay 50;

  (* Treat an eventual new command *)
  let s = recv_new_command () in
  match s with
  | Some (c, s) -> (match c with
       | NewBlock -> (
           let (i, ph, t, d, h) = block_of_buf s in Screen.print_string ("n:"^d);
           if (is_new_block_valid (i, ph, t, d, h) (List.hd chain)) then (
             Screen.print_string "v";
             loop ((i, ph, t, d, h)::chain))
         else Screen.print_string "x"; loop chain)
       | SendChain -> (
           Screen.print_string "c.";
           List.iter send_new_block (List.tl (List.rev chain));
           Screen.print_string ".c";
           loop chain
         ))
  | None -> (
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
        send_new_block b;
        loop (b::chain)
      )
      else if ButtonB.is_on () then (
        Screen.print_string "b";
        let b = create_block (List.hd chain) "b" in
        send_new_block b;
        loop (b::chain)
      )
      else loop chain
    )

let _ =
  Radio.init ();
  ask_chain ();
  try
    loop [create_genesis_block ()]
  with Out_of_memory -> Screen.print_string "mem"
