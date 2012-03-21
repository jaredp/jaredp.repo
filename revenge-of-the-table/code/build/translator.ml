(*Michael Vitrano and Jared Pochtar*)

open Ast
open Namespace
open Namespace_pp

exception Error of string

(* variable declarations; these go in the global scope of the java class *)
let java_of_vdecl ns vdecl =
	let newScope, ((_, jname), lmtype) = scope_with_var ns vdecl in
	let declcode = (java_signature lmtype) ^ " " ^ jname in
	(newScope, declcode)


(* Just to be safe, parenthesise every expr.  Java does this weird thing
where you can't ...; (expr); so to get around that I expose the one that
is unparened, for stmts to use that, but then it uses recursively the parened one. *)

let rvalue (j, t) = j, t, false

let paren str = "("^str^")"

let rec java_of_expr ns expr = 
	let code, ltype, assignable = java_of_unparenthesized_expr ns expr in
    "(" ^ code ^ ")", ltype
and java_of_unparenthesized_expr ns = function      (* returns java, type, isLvalue *)
      Id(var) ->
		(try
	  		let ((vname, javaname), vtype), was_captured = var_of_name ns var in
			javaname, vtype, not was_captured
		 with e -> try		(* maybe it's a column on the default var? *)
		 	let defaultVarAttr = Attr(CurrentVar, (None, var)) in
		   	java_of_unparenthesized_expr ns defaultVarAttr
         with 
            (* hack to allow certain error messages through *)
              e' when e' = (Namespace.Error "ambiguous member access") -> raise e'
            | e' -> raise e
		 )
    | IntLiteral(i) -> string_of_int i, Primitive(Int), false
    | FPLiteral(f) -> string_of_float f, Primitive(Float), false
    | BoolLiteral(b) -> (if b then "true" else "false"), Primitive(Bool), false
    | StringLiteral(s) -> qt (String.escaped s), Primitive(String), false
    | Null(tname, isTable) -> "null", lmtype_of_ast_type ns tname isTable, false
    | Noexpr -> "", Void, false
    
    | Cast(ast_t, expr) ->
            let java_of_expr, expr_type = java_of_expr ns expr in
            let to_type = lmtype_of_ast_type ns ast_t false in
            rvalue (Overloading.java_of_cast java_of_expr expr_type to_type)
                
    | CastToTable(Id(udtname)) when exists_udt_named ns udtname ->
            let udt = udt_of_name ns udtname in
            let ((lmname, jname), _) = udt in
            "new Table("^jname^")", Table(UDT(udt)), false
            
    | CastToTable(expr) -> 
            let java_of_expr, expr_type = java_of_expr ns expr in (
            match expr_type with
                  Singleton(udt) -> "new Table("^java_of_expr^")", Table(udt), false
                | Table(udt) -> java_of_expr, Table(udt), false
                | _ -> raise (Error "can't cast non-singletons to tables")
            )

    | Call("load", [Id(udt_name); filename_expr]) ->
            let udt = udt_of_name ns udt_name in
            let ((_, udt_jname), _) = udt in
                
            let filename_java, filename_type = java_of_expr ns filename_expr in
            if filename_type = Primitive(String) then
                "CsvInterpreter.toTable(WorkingDir.getPath("^filename_java^"), "^udt_jname^")", Table(UDT(udt)), false
            else
                raise (Error "load needs a udt and a string")
    | Call("load", _) -> raise (Error "loadtable needs a udt and a string")

    | Call(fn, args) ->
            rvalue (Overloading.java_of_function_call ns fn (List.map (java_of_expr ns) args))
        
    | Binop(lhs, op, rhs) ->
            let lhs_java, lhs_type, isAssignable = java_of_unparenthesized_expr ns lhs in
            let rhs_java, rhs_type = java_of_expr ns rhs in
            rvalue (Overloading.java_of_binop ns
                isAssignable (paren lhs_java) rhs_java
                (lhs_type, op, rhs_type)
            )
        
    | First(expr) ->
            let java_of_expr, expr_type = java_of_expr ns expr in (
            match expr_type with
                Table(udt) -> java_of_expr^".first()", Singleton(udt), false
                | _ -> java_of_expr, expr_type, false
            )
        
    | Attr(singleton, (attrtype, attr)) -> (
            let java_of_obj, obj_type = java_of_expr ns singleton in
            try (
            match obj_type with
                | Singleton(obj_type) ->
                    let index, coltype = col_index_of_obj obj_type attrtype attr in
                    let data_getter = (match coltype with 
                          Int -> "._Integer"
                        | Float -> "._Float"
                        | String -> "._String"
                        | Bool -> "._Bool"
                    )
                    in let getter = java_of_obj ^ ".entries["^(string_of_int index)^"]"^data_getter
                    in getter, Primitive(coltype), true
                | _ -> raise (Error "access of members of type that doesn't have members")
            )
            with e -> (try
                (* if there's no actual attribute, maybe it's a function call.  fn(e) == e.fn *)
                if attrtype = None then 
                    rvalue (Overloading.java_of_function_call ns attr [(java_of_obj, obj_type)])
                else raise e
            with e' -> raise e)
            )
        
    | CurrentVar -> 
        (match ns.default_variable with
            | None -> raise (Error "can't address default variable here; there's none set")
            | Some(obj_jname, obj_type) -> obj_jname, obj_type, false
        )
        
    | Filter(table_expr, predicate) ->
            (match java_of_expr ns table_expr with 
                | table_java, Table(udt) ->
                    
                    let capturing = { (nest_scope ns) with
                        default_variable = Some("record", Singleton(udt));
                        isCapturing = true
                    } in
                    
                    let pred_java, pred_type = java_of_expr capturing (First predicate) in
                    let pred_call = functor_call capturing pred_java in
                    
                    (match pred_type with
                        | Primitive(Bool) ->
                            let pred_call_java = pred_call
                                "FilterPredicate"
                                "public boolean test(Record record)"
                                None
                            in table_java^".filter("^pred_call_java^")", Table(udt), false

                        | Singleton(map_udt) -> 
                            let pred_call_java = pred_call
                                "FilterMap"
                                "public Record map(Record record)"
                                (Some(map_udt))
                            in table_java^".filterMap("^pred_call_java^")", Table(map_udt), false
                            
                        | _ -> raise (Error "filter predicate is invalid")
                    )
                    
                | _, _ -> raise (Error "filtering on a non-table")
            )
            
        | Join(lhs, predicate, rhs) ->
            (match java_of_expr ns lhs, java_of_expr ns rhs with
                | (lhs_java, Table(lhs_udt)), (rhs_java, Table(rhs_udt)) ->

                    let combined_udt, combined_udt_is_stable =
                        combine_types lhs_udt rhs_udt
                    in
                    
                    let default_var = 
                        if combined_udt_is_stable then
                            Some("record", Singleton(combined_udt))
                        else None
                    in
                    
                    let capturing = { (nest_scope ns) with
                        default_variable = default_var;
                        isCapturing = true
                    } in
                    
                    let capturing = scope_with_jvar_passthrough capturing "a" (Singleton(lhs_udt)) in
                    let capturing = scope_with_jvar_passthrough capturing "b" (Singleton(rhs_udt)) in
                    
                    let pred_java, pred_type = java_of_expr capturing (First predicate) in
                    let pred_call = functor_call capturing pred_java in
                    
                    (match pred_type with
                        | Primitive(Bool) ->
                            if not combined_udt_is_stable then
                                raise (Error ("cannot (non-map) join tables with shared components"))
                            else
                            let pred_call_java = pred_call
                                "JoinPredicate"
                                "public boolean test(Record record, Record a, Record b)"
                                None
                            in lhs_java^".join("^rhs_java^", "^pred_call_java^")", Table(combined_udt), false
                            
                        | Singleton(udt) -> 
                            let pred_call_java = pred_call
                                "JoinMap"
                                "public Record map(Record record, Record a, Record b)"
                                (Some(udt))
                            in lhs_java^".joinMap("^rhs_java^", "^pred_call_java^")", Table(udt), false
                            
                        | _ -> raise (Error "join predicate is invalid")
                    )
                | (_, _), (_, _) -> raise (Error "joining on two things which are not both tables")
            )


let java_of_expr' ns expr = let j, _, _ = (java_of_unparenthesized_expr ns expr) in j
let java_of_pred ns pred = match java_of_unparenthesized_expr ns pred with
      java, Primitive(Bool), _ -> java
    | _ -> raise (Error "used a non-bool where a boolean expression was expected")


let rec java_of_block ns b =
    let finalenv, blockcode = List.fold_left
        (fun (env, code) lmline -> match lmline with
              Statement_line(s) -> (env, code ^ java_of_stmt env s ^ "\n")
            | Vdecl_line(v) ->  let newenv, declcode = java_of_vdecl env v in
                                (newenv, code ^ declcode ^ ";\n")
        ) (nest_scope ns, "") b
    in "{\n" ^ blockcode ^ "\n}"
    
and java_of_stmt ns = function
      Block(body) -> java_of_block ns body
    | Expr(e) -> java_of_expr' ns e ^ ";"
    | Return(expr) -> 
                let retexpr_java, retexprtype = java_of_expr ns expr in
                if ns.returntype = Some(retexprtype) then
                " return " ^ retexpr_java ^ ";"
                else raise (Error "returning wrong type")

    | If(pred, t, e) -> " if (" ^ java_of_pred ns pred ^ ") {"
                        ^ java_of_stmt ns t
                        ^ "} else {"
                        ^ java_of_stmt ns e
                        ^ "}"
    | For(init, pred, post, body) -> 
        " for (" ^ java_of_expr' ns init ^ "; "
                 ^ java_of_pred ns pred ^ "; "
                 ^ java_of_expr' ns post ^ "){"
            ^ java_of_stmt ns body ^
        "}"
    | DoWhile(pre, pred, post) -> 
		" while (true) {"
			^ java_of_stmt ns pre
			^ " if(!("^ java_of_pred ns pred ^ ")) { break; } "
			^ java_of_stmt ns post 
		^ "}"
    | Iter(newvar, table, body) ->
		let ns = nest_scope ns in
		let java_of_table, table_type = java_of_expr ns table in
		match table_type with
			  Table(udt) ->
                let ns, ((_, itervar_jname), _) =
                    scope_with_var_name_type ns newvar (Singleton(udt))
				in 
                "for (Record " ^ itervar_jname ^ " : " ^ java_of_table ^ "){" 
            		^ java_of_stmt ns body ^ 
                "}"
			| _ -> raise (Error "itterating on something not a table")

	
let java_of_program main_class_name program = 
    reset_functors ();
	let ns = new_scope main_class_name in
	
	let ns, udt_decls, udt_builders = List.fold_left
        (fun (env, decls, builders) udtdecl ->
				let newenv, ((lmname, jname), members), declname = scope_with_ast_udt_decl env udtdecl
				in let declcode = "static UserDefinedType " ^ declname ^ ";\n"
				in let buildercode = 
					jname ^ " = new UserDefinedType("^qt lmname^");\n"
				  ^ (String.concat "\n" (List.map 
				  		(fun ((coloftype, colname), colprimtype) ->
							jname^".add("^(qt(coloftype^"'s "^colname))^", "
							^ (match colprimtype with
								  Int -> "Data.INT_TYPE"
								| Float -> "Data.FLOAT_TYPE"
								| String -> "Data.STRING_TYPE"
								| Bool -> "Data.BOOL_TYPE")
							^ ");") members))
				in
				(newenv, decls ^ declcode, builders ^ buildercode ^ "\n\n")
        ) (ns, "", "") program.types
	in
	
	let ns, global_var_decls = List.fold_left
        (fun (env, alldeclcode) vdecl ->
				let newenv, vdeclcode = java_of_vdecl env vdecl in
				(newenv, alldeclcode ^ "static " ^ vdeclcode ^ ";\n")
        ) (ns, "") program.global_vars
	in
	
	let ns, function_decls = List.fold_left
        (fun (env, function_decls) fdecl ->
            let newenv, (_, rettype, _), jname = scope_with_ast_func env fdecl in
            newenv, (jname, rettype, fdecl)::function_decls
        ) (ns, []) program.functions
    in
    
    let java_of_functions = String.concat "\n\n" (List.map (fun (fjname, frettype, fdecl) ->
        let fenv = { (nest_scope ns) with returntype = Some(frettype) } in
        let fenv', formals_decl_code = List.fold_left
            (fun (env, alldeclcode) vdecl ->
                let newenv, vdeclcode = java_of_vdecl env vdecl in
                (newenv, vdeclcode :: alldeclcode)
            ) (fenv, []) fdecl.formals
        in 
        "public static " ^ (java_signature frettype) ^ " " ^ fjname 
        ^"("^(String.concat ", " (List.rev formals_decl_code))^") {\n"
            ^(java_of_stmt fenv' fdecl.body)                
        ^ "}"
        ) function_decls)
	in
"
/*
    Generated by the Return of the Table compiler.
 */


import rtlib.*;
import java.util.Scanner;

" ^ !functor_declarations ^ "

public class "^main_class_name^" {
    " ^ udt_decls ^ global_var_decls ^ java_of_functions ^ "

    private static Scanner input;
		static String globArgs[];
    
	public static void main(String args[]) {
        input = new Scanner(System.in);
				globArgs = new String[args.length];
				for(int globArgCounter = 0; globArgCounter < args.length; globArgCounter++)
					globArgs[globArgCounter] = args[globArgCounter];
				
        "
        
        (* type constructions *)
        ^ udt_builders 
            
        (* program statements *)
        ^ java_of_block ns (List.map (fun s->Statement_line(s)) program.global_code)
        ^ "
    }    
}
"




