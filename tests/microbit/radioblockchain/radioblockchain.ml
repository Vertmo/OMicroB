(* Adapted from https://medium.com/@lhartikk/a-blockchain-in-200-lines-of-code-963cc1cc0e54 *)

open Chain
open Communication

let rec loop chain =
  delay 1;
  trace (string_of_block (block_of_buf (buf_of_block (create_block (List.hd chain) "Coucou"))));
  loop (choose_chain ((create_genesis_block ())::chain) chain) (* TODO *)

let _ = loop [create_genesis_block ()]
