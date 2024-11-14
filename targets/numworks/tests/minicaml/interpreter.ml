(* Interprète Mini-ML *)

open Mml

(* Environnement : associe des valeurs à des noms de variables *)
module Env = Map.Make(String)

(* Valeurs *)
type value =
 | VInt of int
 | VBool of bool
 | VUnit
 | VPtr of int

(* Élements du tas *)
type heap_value =
 | VClos of string * expr * value Env.t
 | VStrct of (string, value) Hashtbl.t

let string_of_bool b =
  if b then "true"
  else "false"

let print_value = function
 | VInt n -> print_int n
 | VBool b -> print_string (string_of_bool b)
 | VUnit -> print_string "()"
 | VPtr p -> print_string "@"; print_int p

(* Interprétation d'un programme complet *)
let eval_prog (p: prog): value =

 (* Initialisation de la mémoire globale *)
 let (mem: (int, heap_value) Hashtbl.t) = Hashtbl.create 32 in

 (* Création de nouvelles adresses *)
 let new_ptr =
 let cpt = ref 0 in
 fun () -> incr cpt; !cpt
 in

 (* Interprétation d'une expression, en fonction d'un environnement
 et de la mémoire globale *)
 let rec eval (e: expr) (env: value Env.t): value =
 match e with
 | Int n -> VInt n
 | Bool b -> VBool b
 | Unit -> VUnit

 | Var v -> Env.find v env

 | Uop(Neg , e1) -> VInt(evali e1 env * -1)
 | Uop(Not , e1) -> (match eval e1 env with |VBool(p) -> VBool(not p )|_ -> failwith "When calling Not e1, e1 must return a bool")

 | Bop(Add, e1, e2) -> VInt(evali e2 env + evali e1 env)
 | Bop(Mul, e1, e2) -> VInt (evali e1 env * evali e2 env)
 | Bop(Sub , e1 , e2) -> VInt(evali e1 env - evali e2 env)
 | Bop(Div , e1 , e2) -> VInt(evali e1 env / evali e2 env)
 | Bop(Mod , e1 , e2) -> VInt(evali e1 env mod evali e2 env)
 | Bop(Eq, e1, e2) -> let v1 = eval e1 env in let v2 = eval e2 env in VBool (v1 = v2)
 | Bop(Neq, e1, e2) -> let v1 = eval e1 env in let v2 = eval e2 env in VBool (v1 != v2)
 | Bop(Lt , e1 , e2) -> VBool(evali e1 env < evali e2 env)
 | Bop(Le , e1 , e2) -> VBool(evali e1 env <= evali e2 env)
 | Bop(And , e1 , e2) -> if evalb e1 env then VBool(evalb e2 env) else VBool(false)
 | Bop(Or , e1 , e2) -> if evalb e1 env then VBool(true) else VBool(evalb e2 env)

 | If(e1, e2, e3) -> if evalb e1 env then eval e2 env else eval e3 env

 | Let(x ,e1 , e2) -> let v = eval e1 env in let env1 = (Env.add x v env) in eval e2 env1

 | Fun(x,typ,e) -> let ptr = new_ptr() in let v = VClos(x,e,env) in Hashtbl.add mem ptr v ; VPtr ptr

 | App(e1, e2) -> let v1 = eval e1 env in  let v2 = eval e2 env in
 begin match v1 with
 |VPtr(p) ->
 (match Hashtbl.find mem p with
 | VClos(x, e, cl_env) ->
 let env' = Env.add x v2 cl_env in
 eval e env'
 | _ -> failwith "not a function")
 | _ -> failwith "not a function"
 end

 | Seq(e1, e2) -> let _ = eval e1 env in eval e2 env

 | Strct(champs) ->
 let struct_champs = Hashtbl.create (List.length champs) in
 List.iter (fun (x,e) -> Hashtbl.add struct_champs x (eval e env)) champs;
 let ptr = new_ptr() in
 let v = VStrct(struct_champs) in
 Hashtbl.add mem ptr v;
 VPtr ptr

 | GetF(strct,s) -> let v = (eval strct env) in (match v with |VPtr(v) -> (let hv = (Hashtbl.find mem v) in match hv with | VStrct champs -> Hashtbl.find champs s|_ -> failwith "le champs n'a pas été trouvé")|_ -> failwith "You can only get access to a structure")


 |SetF(v,s,e) -> let hv = (Hashtbl.find mem (match (eval v env) with |VPtr(v)-> v|_-> failwith "you can only have access a field if the variable is a structure")) in (match hv with | VStrct champs -> Hashtbl.replace champs s (eval e env); VUnit |_ -> failwith "le champs n'a pas été trouvé")

 |Fix(x,tx,e) ->
      (match e with
      |Fun(x1,tx1,e1) ->
        let ptr = new_ptr() in
        let v = VClos(x1,e1,Env.add x (VPtr ptr) env) in
        Hashtbl.add mem ptr v;
        VPtr ptr
      |Strct(champs) ->
        let struct_champs = Hashtbl.create (List.length champs) in
        let ptr = new_ptr() in
        let v = VStrct(struct_champs) in
        List.iter (fun (x,e) -> Hashtbl.add struct_champs x (eval e (Env.add x (VPtr ptr) env))) champs;
        Hashtbl.add mem ptr v;
        VPtr ptr
      |_-> failwith "Fix must be used with a function or a structure")

 |For(x,e1,e2,e3) ->
    let v1 = evali e1 env in
    let v2 = evali e2 env in
    let direction = if v1 < v2 then 1 else -1 in
    let env1 = Env.add x (VInt(v1)) env in
    let rec loop (e: expr) (env: value Env.t) : value =
      (match Env.find x env with
      |VInt(n) -> if n = v2 then VUnit else let _ = eval e3 env in loop e3 (Env.add x (VInt(n+direction)) (Env.remove x env) )
      |_-> failwith "you must enter a int")
    in loop e3 env1

  |While(e1,e2) ->
    let rec loop (e: expr) (env: value Env.t) : value =
      if evalb e1 env then let z= eval e2 env in loop e2 env
      else VUnit
    in loop e2 env

 and evali (e: expr) (env: value Env.t): int =
 match eval e env with
 | VInt n -> n
 | _ -> failwith "you must enter a int"

 and evalb (e: expr) (env: value Env.t): bool =
 match eval e env with
 | VBool n -> n
 | _ -> failwith "you must enter a bool"
 in

 eval p.code Env.empty
