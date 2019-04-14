open Chain

(** Command sent or received *)
type command = NewBlock | SendChain

let char_of_command = function
  | NewBlock -> 'n'
  | SendChain -> 'c'

let command_of_char = function
  | 'n' -> NewBlock
  | 'c' -> SendChain
  | _ -> invalid_arg "command_of_char"

(** Translate a block to a buffer *)
let buf_of_block ((i, ph, t, d, h):block):string =
  (String.make 1 i)^
  (String.make 1 ph)^
  (String.concat "" (List.map (fun c -> String.make 1 c) (char_list_of_int t)))^
  (String.make 1 h)^d

let block_of_buf (s:string):block =
  ((String.get s 0),
   (String.get s 1),
   int_of_char_list [String.get s 2; String.get s 3; String.get s 4; String.get s 5],
   String.sub s 7 ((String.length s)-7),
   (String.get s 6))

(** Send a new block *)
let send_new_block (b:block):unit =
  Radio.send ((String.make 1 (char_of_command NewBlock))^(buf_of_block b))

(** Receive a command *)
let recv_new_command () =
  let s = Radio.recv () in
  if s = "" then None
  else Some (command_of_char (String.get s 0), (String.sub s 1 ((String.length s)-1)))

(** Ask for to receive the chain *)
let ask_chain () =
  Radio.send (String.make 1 (char_of_command SendChain))
