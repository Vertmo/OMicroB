(* Eratosthene's sieve *)

(* interval min max = [min; min+1; ...; max-1; max] *)

let rec interval min max =
  if min > max then [] else min :: interval (min + 1) max

(* Application: removing all numbers multiple of n from a list of integers *)

let remove_multiples_of n =
  List.filter (fun m -> not ((m mod n) = 0))

(* The sieve itself *)

let sieve max =
  let rec filter_again = function
      [] -> []
    | n::r as l ->
      if n*n > max then l else n :: filter_again (remove_multiples_of n r)
  in
  filter_again (interval 2 max)

let _ =
  Serial.init ();
  Serial.write "START";
  Serial.write "\n";
  let n = millis () in
  begin
    try
      for i = 0 to 100 do
        Serial.write (string_of_int i);
        Serial.write "-";
        ignore(sieve 30);
        Serial.write (string_of_int (Gc.collections ()));
        Serial.write "-";
        Serial.write (string_of_int (Gc.used_stack_size ()));
        Serial.write "\n";
      done
    with Stack_overflow -> Serial.write "STACKOVERFLOW\n"
       | Out_of_memory -> Serial.write "OUTOFMEMORY\n"
       | _ -> Serial.write "?"
  end;
  let n' = millis () in
  Serial.write (string_of_int (n'-n));
  Serial.write "STOP";
