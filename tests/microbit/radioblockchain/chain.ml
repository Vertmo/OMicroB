(** The data in our blocks is a string (this is going to hurt the memory) *)
type block = (char * char * int * string * char) (* index, previousHash, timestamp, data (24 char max), hash *)

(** A naive hashing function *)
let my_simple_hash i prev time data =
  char_of_int ((31 * (i + 31 * (prev + 31 * (time + 31 * (String.length data))))) land 255)

(** Create a new block *)
let create_block ((index, _, _, _, pHash):block) (msg:string):block =
  let t = millis () and i = (int_of_char index) + 1 in
  ((char_of_int i), pHash, t, msg, my_simple_hash i (int_of_char pHash) t msg)

(** Create the genesis block *)
let create_genesis_block ():block =
  ((char_of_int 0), (char_of_int 0), 0, "genesis", my_simple_hash 0 0 0 "genesis")

(** Verify the last block *)
let is_new_block_valid ((nI, npH, nT, nD, nH):block) ((pI, _, _, _, pH):block):bool =
  if nI <> char_of_int ((int_of_char pI) + 1) then false
  else if npH <> pH then false
  else if (my_simple_hash (int_of_char nI) (int_of_char npH) nT nD) <> nH then false
  else true

(** Verify the whole chain *)
let rec is_chain_valid (chain: block list) = match chain with
  | [] -> true
  | _::[] -> true
  | nb::pb::q -> is_new_block_valid nb pb && (is_chain_valid (pb::q))

(** Choose the new chain if it is valid and longer than the old *)
let choose_chain newC oldC =
  if (is_chain_valid newC) && (List.length newC) > (List.length oldC) then newC else oldC

(** Util to convert an u32 into a list of char *)
let char_list_of_int i = [
  char_of_int ((i lsr 24) land 255);
  char_of_int ((i lsr 16) land 255);
  char_of_int ((i lsr 8) land 255);
  char_of_int (i land 255)
]

(** Util to convert a list of char to a u32 *)
let int_of_char_list l =
  if(List.length l <> 4) then invalid_arg "int_of_char_list";
  (int_of_char (List.nth l 0)) lsl 24 +
  (int_of_char (List.nth l 1)) lsl 16 +
  (int_of_char (List.nth l 2)) lsl 8 +
  int_of_char (List.nth l 3)

(** Translate the block to a string, for debug purposes *)
let string_of_block ((i, ph, t, d, h):block):string =
  (string_of_int (int_of_char i))^"/"^
  (string_of_int (int_of_char ph))^"/"^
  (string_of_int t)^"/"^
  (string_of_int (int_of_char h))^"/"^d
