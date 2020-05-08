open Proj2_types;;

let getStartSymbol (g : grammar) : string =
  (* YOUR CODE GOES HERE *)
  match g with
  | (a,b) -> a
  ;;

  let rec genList l =
    match l with
    | [] -> []
    | (a,b) :: tl -> a :: genList ( tl );;
let getNonterminals (g : grammar) : string list =
  (* YOUR CODE GOES HERE *)
  match g with
  | (a,b) -> genList b
  ;;

  let rec genMapFirst l =
    match l with
    | [] -> SMap.empty
    | hd :: tl -> SMap.add hd SymbolSet.empty (genMapFirst tl);; 
let getInitFirstSets (g : grammar) : symbolMap =
  (* YOUR CODE GOES HERE *)
  genMapFirst (getNonterminals g);;

  let rec genMapFollow l =
    match l with
    | [] -> SMap.empty
    | hd :: tl -> SMap.add hd (SymbolSet.empty) (genMapFollow tl);; 

let getInitFollowSets (g : grammar) : symbolMap =
  (* YOUR CODE GOES HERE *)
  SMap.add (getStartSymbol g) (SymbolSet.singleton "eof") (genMapFollow (getNonterminals g));;

let rec computeFirstSet (first : symbolMap) (symbolSeq : string list) : SymbolSet.t =
  (* YOUR CODE GOES HERE *)
  match symbolSeq with
  | [] -> SymbolSet.singleton "eps"
  | hd :: tl -> if (SMap.mem hd first) then (if (SymbolSet.mem "eps" (SMap.find hd first)) then (SymbolSet.union (SymbolSet.remove "eps" (SMap.find hd first)) (computeFirstSet first tl)) else SMap.find hd first)
                else SymbolSet.singleton hd
  ;;

    let rec recurseHelper l first firstFunc =
      match l with
      | [] -> first
      | (a,b) :: tl -> SMap.add a (SymbolSet.union (firstFunc first b) (SMap.find a (recurseHelper tl first firstFunc))) (recurseHelper tl first firstFunc);;
let recurseFirstSets (g : grammar) (first : symbolMap) firstFunc : symbolMap =
  (* YOUR CODE GOES HERE *)
  match g with
  | (a,b) -> recurseHelper b first firstFunc;;

let rec getFirstSets (g : grammar) (first : symbolMap) firstFunc : symbolMap =
  (* YOUR CODE GOES HERE *)
  if (first = (recurseFirstSets g first firstFunc)) then first else (getFirstSets g (recurseFirstSets g first firstFunc) firstFunc);;

let rec updateFollowSet (first : symbolMap) (follow : symbolMap) (nt : string) (symbolSeq : string list) : symbolMap =
  (* YOUR CODE GOES HERE *)
   match symbolSeq with
   | [] -> follow
   | hd :: tl -> if (SMap.mem hd follow) then 
                        (if (SymbolSet.mem "eps" (computeFirstSet first tl)) then 
                            (SMap.add hd (SymbolSet.union (SymbolSet.union (SymbolSet.remove "eps" (computeFirstSet first tl)) (SMap.find hd (updateFollowSet first follow nt tl))) (SMap.find nt follow))((updateFollowSet first follow nt tl))) 
                         else (SMap.add hd (SymbolSet.union (computeFirstSet first tl) (SMap.find hd (updateFollowSet first follow nt tl))) (updateFollowSet first follow nt tl)))
                 else (updateFollowSet first follow nt tl);;

let recurseFollowSets (g : grammar) (first : symbolMap) (follow : symbolMap) followFunc : symbolMap =
  (* YOUR CODE GOES HERE *)
  let rec recurseHelperFollow l followMap =
    match l with
    | [] -> followMap
    | (nt,symbolSeq) :: tl -> recurseHelperFollow tl (followFunc first followMap nt symbolSeq)

  in match g with
  | (a,b) -> recurseHelperFollow b follow
  ;;  
  
  (*maybe change some stuff around with this*)
  let compareSMap x y =
    SMap.equal ( fun x y -> SymbolSet.equal x  y ) x y ;;

let rec getFollowSets (g : grammar) (first : symbolMap) (follow : symbolMap) followFunc : symbolMap =
  (* YOUR CODE GOES HERE *)
  if ( compareSMap follow (recurseFollowSets g first follow followFunc)) then follow else (getFollowSets g first (recurseFollowSets g first follow followFunc) followFunc);;

  let rec predictSets l first follow firstFunc =
    match l with
    | [] -> []
    | (a,b) :: tl -> if( SymbolSet.mem "eps" (firstFunc first b)(*(SMap.find a first)*)) then ((a,b), (SymbolSet.union (SymbolSet.remove "eps" (firstFunc first b))(SMap.find a follow))) :: (predictSets tl first follow firstFunc) 
                      else ( (a,b), (firstFunc first b) ) :: (predictSets tl first follow firstFunc);;
let rec getPredictSets (g : grammar) (first : symbolMap) (follow : symbolMap) firstFunc : ((string * string list) * SymbolSet.t) list =
  (* YOUR CODE GOES HERE *)
  match g with
  | (a,b) -> predictSets b first follow firstFunc;;

let tryDerive (g : grammar) (inputStr : string list) : bool =
  (* YOUR CODE GOES HERE *)
  let first = (getFirstSets g (getInitFirstSets g) computeFirstSet)
  in let predict = getPredictSets g first (getFollowSets g first (getInitFollowSets g) updateFollowSet) computeFirstSet

  in let remove stack_liist = 
    match stack_liist with
    | [] -> []
    | hd :: tl -> tl    

  in let rec findPredict prodRule x currentToken stackList =
    match prodRule with
      | [] -> stackList
      | (productionRule, predict) :: rest -> 
          
        match productionRule with
        | (nt, symbolSeq) ->  
            if (x = nt) then  
            ( if(SymbolSet.mem currentToken predict) then symbolSeq@(remove stackList)
              else (findPredict rest x currentToken stackList) ) 
            else (findPredict rest x currentToken stackList)

  in let top stackList : string = 
      match stackList with
      | [] -> ""
      | hd :: tl -> hd 
 
  in let rec derive stackList other : bool = 
      if ((top stackList) <> "eof") then
      (
        if (List.mem (top stackList) (getNonterminals g)) then 
        (
            let newStackList = findPredict predict (top stackList) (top other) stackList
            in 
              if (newStackList = stackList) then  
                derive (remove newStackList) other 
              else
                derive newStackList other )
        else
        ( if ((top stackList) = (top other)) then     
            derive (remove stackList) (remove other)
          else
            false )
      )
      else
        if ((top other) <> "eof") then false else true

  in derive ([]@[(getStartSymbol g)]@["eof"]) (inputStr@["eof"]);;

let tryDeriveTree (g : grammar) (inputStr : string list) : parseTree =
  (* YOUR CODE GOES HERE *)
Terminal "empty";;

let genParser g = tryDerive g;;
let genTreeParser g = tryDeriveTree g;;
