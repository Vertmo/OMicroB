
(* $Id: oDivE.ml,v 1.1 2008-08-29 09:10:43 adrien Exp $ *)

type xXunit =  Xtt_C;;
type xXbool =  Xtrue_C |  Xfalse_C;;
type nat =  O_C |  S_C of nat;;
type ('b,'a) prod =  Xpair_C of ('a * 'b) ;;
type sumbool =  Xleft_C |  Xright_C;;
type 'a sumor =  Xinleft_C of 'a |  Xinright_C;;
let xXfst u = (fun (Xpair_C (xVAR3,xVAR4)) -> xVAR3) u;;
let xXsnd u = (fun (Xpair_C (xVAR3,xVAR4)) -> xVAR4) u;;

exception Failure of string;;
let fail () = raise (Failure "fail");;

let le_or_gt n =
 let rec xVAR1 xVAR2 =
  (match xVAR2 with
     O_C -> (fun m -> Xleft_C)
   | S_C xVAR3 ->
       (fun m ->
             (match m with
                O_C -> Xright_C
              | S_C xVAR3prime ->
                  (match xVAR1 xVAR3 xVAR3prime with
                     Xleft_C -> Xleft_C | Xright_C -> Xright_C ))))in
  xVAR1 n;;

let xO_or_S n =
 (match n with O_C -> Xinright_C | S_C xVAR3 -> Xinleft_C xVAR3);;


let le_or_s n =
 let rec xVAR1 xVAR2 =
  (match xVAR2 with
     O_C -> (fun m -> Xleft_C)
   | S_C xVAR3 ->
       (fun m ->
             (match m with
                O_C -> Xright_C
              | S_C xVAR3prime ->
                  (match xVAR1 xVAR3 xVAR3prime with
                     Xleft_C -> Xleft_C | Xright_C -> Xright_C ))))
in
  xVAR1 n
;;

let gt_S_s n m =
 (match le_or_gt n m with
    Xleft_C ->
      (match le_or_s m n with Xleft_C -> Xright_C | Xright_C -> fail ())
  | Xright_C -> Xleft_C);;

let division_extractible n d =
 let rec xVAR1 xVAR2 =
  (match xVAR2 with
     O_C -> Xpair_C (O_C,O_C)
   | S_C xVAR3 ->
       (match d with
          O_C ->
            (match fail () with
                Xleft_C -> Xpair_C (xXfst (xVAR1 xVAR3),S_C (xXsnd (xVAR1 xVAR3)))
              | Xright_C -> Xpair_C (S_C (xXfst (xVAR1 xVAR3)),O_C))
        | S_C xVAR3prime ->
            (match gt_S_s xVAR3prime (xXsnd (xVAR1 xVAR3)) with
               Xleft_C -> Xpair_C (xXfst (xVAR1 xVAR3),S_C (xXsnd (xVAR1 xVAR3))) 
             | Xright_C -> Xpair_C (S_C (xXfst (xVAR1 xVAR3)),O_C) ))) in
  xVAR1 n;;

let rec xPLUS n p = match p with O_C -> n | (S_C m) -> (S_C (xPLUS n m));;

let rec print_nat = function O_C -> print_int 0 | S_C n -> print_string "S_C ";print_nat n;;

let print_resultat = function Xpair_C (a,b) -> print_nat a; print_string "-->";print_nat b;;

let () =
  clear_screen ();

  let start_time = millis () in

  let xUN = S_C O_C in
  let xDEUX = S_C xUN in
  let xTROIS = S_C xDEUX in
  let xSIX = xPLUS xTROIS xTROIS in
  let xDOUZE = xPLUS xSIX xSIX in
  let xDIXH = xPLUS xDOUZE xSIX in

  print_resultat (division_extractible xDOUZE xDOUZE);
  print_newline();

  let end_time = millis () in
  print_string "runtime: "; print_int (end_time-start_time); print_endline "ms";

  while true do () done;;
