open Chain

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

