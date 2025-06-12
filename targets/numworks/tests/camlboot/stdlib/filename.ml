let concat s1 s2 = s1^"/"^s2

let generic_basename is_dir_sep current_dir_name name =
  let rec find_end n =
    if n < 0 then String.sub name 0 1
    else if is_dir_sep name n then find_end (n - 1)
    else find_beg n (n + 1)
  and find_beg n p =
    if n < 0 then String.sub name 0 p
    else if is_dir_sep name n then String.sub name (n + 1) (p - n - 1)
    else find_beg (n - 1) p
  in
  if name = ""
  then current_dir_name
  else find_end (String.length name - 1)

let current_dir_name = "."
let is_dir_sep s i = s.[i] = '/'
let basename = generic_basename is_dir_sep current_dir_name

let extension_len name =
  let rec check i0 i =
    if i < 0 || is_dir_sep name i then 0
    else if name.[i] = '.' then check i0 (i - 1)
    else String.length name - i0
  in
  let rec search_dot i =
    if i < 0 || is_dir_sep name i then 0
    else if name.[i] = '.' then check i (i - 1)
    else search_dot (i - 1)
  in
  search_dot (String.length name - 1)

let remove_extension name =
  let l = extension_len name in
  if l = 0 then name else String.sub name 0 (String.length name - l)
