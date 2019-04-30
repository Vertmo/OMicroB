open Imp

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

let exec s =
  Serial.write s; Serial.write "\n";
  let parse_res = parse (explode s) in
  (match parse_res with
     NoneE _ -> Serial.write ("Syntax error\n");
  | SomeE c ->
      let fuel = 1000 and start_time = millis () in
      match (ceval_step empty_st c fuel) with
        None ->
        Serial.write
            ("Still running after " ^ string_of_int fuel ^ " steps\n")
      | Some res ->
          Serial.write (
              "Result: "
              ^ string_of_int (res ['z']) ^ "\n"^
              "Temps de calcul: "^(string_of_int (millis ()-start_time)^"ms\n")))

let fibo_imp =
  "w::=15;; x::=0;; y::=1;;
   WHILE 2 <= w DO
     z::=x+y;;
     x::=y;;
     y::=z;;
     w::=w-1
   END"

let _ =
  Serial.init ();
  exec fibo_imp
