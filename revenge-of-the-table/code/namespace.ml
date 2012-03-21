(*Michael Vitrano and Jared Pochtar*)


open Ast

exception Error of string

type lm_java_name = string * string (* lmname, jname *)

type lmprimitive = 
	  Int
	| Float
	| String
	| Bool

type colname = string * string (* first str is typename *)
type lmudt = lm_java_name * (colname * lmprimitive) list
type lmtuple = lmudt list

type lmobjecttype = 
	  UDT of lmudt
	| TupleUDT of lmtuple
    
type lmtype =
	  Primitive of lmprimitive
	| Singleton of lmobjecttype
	| Table of lmobjecttype
	| Void
    
type lmvar = lm_java_name * lmtype
type lmfuncsig = lm_java_name * lmtype * lmtype list
	
type nsobject =
	  NSVar of lmvar
	| NSFunc of lmfuncsig
	| NSUDT of lmudt

type namespace = {
	super_scope : namespace option;
    objects : (string * nsobject) list;
    
    next_id_index : int;
    main_class_name : string;
    
    returntype : lmtype option;
    default_variable : (string * lmtype) option;    (* for .col in a filter *)
    
    captures : nsobject list ref;       (* for capuring objs/func captures in filters/joins *)
    isCapturing : bool
}

let next_id ns = "rt" ^ (string_of_int ns.next_id_index),
                 { ns with next_id_index = ns.next_id_index + 1 }

let new_scope mainclass =
                { super_scope = None; objects = [];
                  next_id_index = 0; main_class_name = mainclass;
                  returntype = None; default_variable = None; 
                  captures = ref []; isCapturing = false }

let nest_scope scope = { scope with 
    super_scope = Some(scope);
    objects = [];
    
    isCapturing = false;
    captures = ref [];
}



                (* ocaml utils *)

let qt str = "\"" ^ str ^ "\""

let list_of_unique_elements l =
    let rec uniq accum = function
          [] -> accum
        | e::rs -> uniq (if List.exists (fun x -> x = e) accum then accum else e::accum) rs
    in List.rev (uniq [] l)

let rec list_elements_are_unique = function
      [] -> true
    | e::rs -> 
        if (List.mem e rs) then false else 
        list_elements_are_unique rs

let index_of fn list =  (* returns (index, element, isunique) option *)
    let rec index fn i = function
          [] -> None
        | e::r -> 
                if fn(e) then
                    Some(i, e, (index fn 0 r) = None)
                else 
                    index fn (i + 1) r
    in index fn 0 list



                (* java signatures *)
            
let java_type_of_primitive_type = function
      Int -> "int"
    | Float -> "double"
    | String -> "String"
    | Bool -> "boolean"
	
let java_signature = function
	  Primitive(p) -> java_type_of_primitive_type p
	| Singleton(_) -> "Record"
	| Table(_) -> "Table"
	| Void -> "void"
    
    
                (* Scope functions *)

let rec flatten_scope ns =
	let objs = ns.objects in
	match ns.super_scope with
		  None -> objs
		| Some(ns') -> objs @ flatten_scope ns'
		
let string_of_scope ns = 
	let flat = List.map fst (flatten_scope ns) in
	"[" ^ (String.concat "; " flat) ^ "]"

(* get object *)
let rec obj_named ns id =       (* returns the obj, if it was captured *)
	try
		let _, obj = List.find (fun (name, obj) -> name = id) ns.objects
		in Some(obj, false)
	with Not_found -> match ns.super_scope with
		  None -> None
		| Some(super) -> 
            if not ns.isCapturing
            then obj_named super id
            else match obj_named super id with
                  None -> None
                | Some(ssobj, _) ->
                    ns.captures := (ssobj)::!(ns.captures);
                    Some(ssobj, true)
                
(* add object *)
let scope_with_obj_of_name_ignoring_shadowing scope obj name =
    { scope with objects = (name, obj)::(scope.objects) }

let builtin_function_names = ["print"; "commit"; "th"; "size"; "stdin"; "setWorkingDir"; "substring"; "strlen"; "charAt"; "system"; "delete"; "argc"; "argv"; "tl"]

let scope_with_obj_of_name scope obj (name : string) =
	if not ((obj_named scope name) = None) then 
        raise (Error ("redeclaring " ^ name ^ " where there's " ^ (string_of_scope scope)))
    else if (List.mem name builtin_function_names) then
        raise (Error ("redeclaring built in function "^name))
	else scope_with_obj_of_name_ignoring_shadowing scope obj name
    


                (* UDT functions: get index+type of column by name. *)
                
(* use the last one, col_index_of_obj with udt, col type qualifier option, colname *)

let col_index_of_tuple tuple col_on_type colname =
	let allcols = List.flatten (List.map snd tuple) in
    match index_of (fun ((col_on_type', colname'), _) ->
        col_on_type = col_on_type' && colname = colname')
        allcols
	with
	  Some(index, (_, coltype), true) -> Some(index, coltype)
    | Some(_, _, false) -> raise (Error "internal error: duplicate unambiguous member access")
	| None -> None

let unqualified_col_index_of_tuple tuple colname =
	let allcols = List.flatten (List.map snd tuple) in
    match index_of 
        (fun ((_, colname'), _) -> colname = colname')
        allcols
	with
	  Some(index, (_, coltype), true) -> Some(index, coltype)
    | Some(_, _, false) -> raise (Error "ambiguous member access")
	| None -> None

let col_index_of_obj obj col_on_type colname =
    let colindex = match obj, col_on_type with
          UDT(x), Some(coltype) ->      col_index_of_tuple [x] coltype colname
        | TupleUDT(x), Some(coltype) -> col_index_of_tuple x coltype colname
        | UDT(x), None ->               unqualified_col_index_of_tuple [x] colname
        | TupleUDT(x), None ->          unqualified_col_index_of_tuple x colname
    in match colindex with
          None -> raise (Error "accessing member that doesn't exist")
        | Some(index) -> index

let combine_types lhs rhs = 
    let udt_list_of_lmobject = function
          UDT(lmudt) -> [lmudt]
        | TupleUDT(lmudts) -> lmudts
    in
    let combined = 
        (udt_list_of_lmobject lhs)@(udt_list_of_lmobject rhs)
    in
    TupleUDT(combined), list_elements_are_unique combined

let java_of_udt = function
      UDT((_, jname), _) -> jname
    | TupleUDT(udts) ->
        let lm_java_udt_names = List.map fst udts in
        let compound_name = String.concat "#" (List.map fst lm_java_udt_names) in
        let java_of_udts = String.concat ", " (List.map snd lm_java_udt_names) in
        "new TupleType("^qt(compound_name)^", "^java_of_udts^")"

(* NSUDT functions *)
(* get UDT *)
let udt_of_name scope udtname =
	match obj_named scope udtname with
		  None -> raise (Error ("no type named "^udtname))
		| Some(NSUDT(udt), _) -> udt
		| Some(_) -> raise (Error (udtname^" is not a type"))

(* exists *)
let exists_udt_named ns udtname =
    match obj_named ns udtname with
          None -> false
        | Some(NSUDT(_), _) -> true
        | Some(_) -> false
    

                    (* type functions *)

(* AST TYPE -> LMTYPE *)
let lmtype_of_ast_type ns ast_type istable =
    match ast_type with
          Ast.Int -> Primitive(Int)
        | Ast.Float -> Primitive(Float)
        | Ast.String -> Primitive(String)
        | Ast.Bool -> Primitive(Bool)
        | Ast.Void -> Void
        | Ast.Udt(name) -> 
            let udt = udt_of_name ns name in
            if istable then Table(UDT(udt)) else Singleton(UDT(udt))
        | Ast.Tuple(udt_names) ->
            let udts = List.map (udt_of_name ns) udt_names in
            if istable then Table(TupleUDT(udts)) else Singleton(TupleUDT(udts))




                    (* NSUDT functions *)
(* add UDT *)
let scope_with_ast_udt_decl ns (udt_decl : Ast.type_decl) =
    let member_of_ast_vdecl vdecl =
        match (lmtype_of_ast_type ns vdecl.vtype vdecl.isTable) with
              Primitive(p) -> ((udt_decl.tname, vdecl.vname), p)
            | _ -> raise (Error "improper type in a UDT member")
    in
    let members = List.map member_of_ast_vdecl udt_decl.members in
    
    if not (list_elements_are_unique (List.map fst members)) then
        raise (Error "duplicate member in udt declaration")
    else
    
    let name, ns = next_id ns in
	let udt = (udt_decl.tname, ns.main_class_name^"."^name), members in
    (scope_with_obj_of_name ns (NSUDT(udt)) udt_decl.tname), udt, name




                    (* NSVar functions *)
(* add var *)
let scope_with_var_name_type ns varname vartype =
    if vartype = Void then raise (Error "variable cannot have type void") else
    let name, ns = next_id ns in
	let lmv = (varname, name), vartype in
    (scope_with_obj_of_name ns (NSVar lmv) varname), lmv

let scope_with_jvar_passthrough scope varname vartype =
    scope_with_obj_of_name_ignoring_shadowing 
        scope 
        (NSVar((varname, varname), vartype))
        varname

let scope_with_var ns var =
    let vartype = lmtype_of_ast_type ns var.vtype var.isTable in
    scope_with_var_name_type ns var.vname vartype
    
(* get var *)
let var_of_name ns name =
 	match obj_named ns name with
		  None -> raise (Error ("no var named "^name^" in scope "^(string_of_scope ns)))
		| Some(NSVar(v), was_captured) -> v, was_captured
		| Some(_) -> raise (Error (name^" is not a variable"))




                    (* NSFunc functions *)

(* add fsig *)
let scope_with_ast_func ns func_decl =
    let rettype = lmtype_of_ast_type ns func_decl.rettype func_decl.ret_table in
    let formals = List.map 
        (fun v ->
            let ft = lmtype_of_ast_type ns v.vtype v.isTable in
            if ft = Void then raise (Error "function argument cannot be of type void")
            else ft)
        func_decl.formals
    in
    let name, ns = next_id ns in
    let fsig = ((func_decl.fname, ns.main_class_name^"."^name), rettype, formals) in
    (scope_with_obj_of_name ns (NSFunc fsig) func_decl.fname), fsig, name

(* get fsig *)
let funcsig_of_name ns name =
 	match obj_named ns name with
		  None -> raise (Error ("no function named "^name^" in scope "^(string_of_scope ns)))
		| Some(NSFunc(f), _) -> f
		| Some(_) -> raise (Error (name^" is not a variable"))



                    (* functor handling *)

let functor_declarations = ref ""
let functor_next_id = ref 0

let reset_functors u =
    functor_declarations := "";
    functor_next_id := 0

let get_new_functor_name ns =
    functor_next_id := !functor_next_id + 1;
    ns.main_class_name^"_anonymous_functor_" ^ (string_of_int !functor_next_id)
    
let add_functor ftor =
    functor_declarations := (!functor_declarations ^ ftor)
    
let getCaptures capturing_scope =
    List.fold_left (fun accum v -> match v with 
          NSVar((_, jname), vtype) -> (jname, (java_signature vtype))::accum
        | _ -> accum
    ) [] (list_of_unique_elements !(capturing_scope.captures))

let functor_call pred_capturing_scope test_java proto_name test_sig getType =
    let captures = getCaptures pred_capturing_scope in
    let ft_name = get_new_functor_name pred_capturing_scope in
    let ftor =
        "class "^ft_name^" implements "^proto_name^" {\n"
            (* ivars = captured variables *)
            ^ (String.concat "\n" (List.map
                    (fun (jid, jsig) -> jsig^" "^jid^";")
                    captures))
            ^ "\n\n"
            
            (* ctor to initialize captures *)
            ^ ft_name^"("
            ^ (String.concat ", " (List.map
                    (fun (jid, jsig) -> jsig^" _"^jid)
                    captures))
            ^ "){"
            ^ (String.concat "\n" (List.map
                    (fun (jid, jsig) -> jid^" = _"^jid^";")
                    captures))
            ^ "}\n"
                   
            (* code captured *)
            ^test_sig^" {
                return "^test_java^";
            }"
            ^ (match getType with None -> "" | Some(udt) ->
                "public UserDefinedType getType() {
                    return "^java_of_udt udt^";
                }\n"
            )
            ^"}\n"
        in add_functor ftor;
                    
    "new "^ft_name^"("^(String.concat ", " (List.map fst captures))^")"


