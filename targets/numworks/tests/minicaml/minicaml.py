let rec fibonacci (n: int) :int =
  if n <= 1 then
    n
  else
    fibonacci (n-1) + fibonacci (n-2)
in
fibonacci 15
