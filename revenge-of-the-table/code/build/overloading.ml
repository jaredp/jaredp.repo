(*Michael Vitrano and Jared Pochtar*)

open Ast
open Namespace
open Namespace_pp
exception Error of string

(* 
   operator overloading goes here! first get the types of the subexprs,
   then match on (lhstype, op, rhstype)
   (Int, Add, Int) -> something
   (Table, Add, Table) -> something different
   and so on
*)

let requires_assignable assignable = 
    if not assignable then
        raise (Error ("lhs of assign is not an lvalue"))
    else ()

let java_of_binop ns isAssignable lhs_java rhs_java = function
	| Primitive(String), Add, Primitive(String) ->
				lhs_java ^ "+" ^ rhs_java, Primitive(String)
				
	| Primitive(Int), Add, Primitive(Int) -> lhs_java ^ "+" ^ rhs_java, Primitive(Int)
	| Primitive(Float), Add, Primitive(Float)
	| Primitive(Int), Add, Primitive(Float)
	| Primitive(Float), Add, Primitive(Int) -> lhs_java ^ "+" ^ rhs_java, Primitive(Float)
	
    | Table(ttype), Add, Singleton(rtype) when ttype=rtype ->
                lhs_java^".addRow("^rhs_java^")", Table(ttype)
    | Table(ttype), Add, Table(rtype) when ttype=rtype ->
                lhs_java^".append("^rhs_java^")", Table(ttype)
    | Singleton(ttype), Add, Table(rtype) when ttype=rtype ->
                rhs_java^".prepend("^lhs_java^")", Table(ttype)    
    
	| Primitive(Int), Sub, Primitive(Int) -> lhs_java ^ "-" ^ rhs_java, Primitive(Int)
	| Primitive(Float), Sub, Primitive(Float)
	| Primitive(Int), Sub, Primitive(Float)
	| Primitive(Float), Sub, Primitive(Int) -> lhs_java ^ "-" ^ rhs_java, Primitive(Float)
	
	| Primitive(Int), Mult, Primitive(Int) -> lhs_java ^ "*" ^ rhs_java, Primitive(Int)
	| Primitive(Float), Mult, Primitive(Float)
	| Primitive(Int), Mult, Primitive(Float)
	| Primitive(Float), Mult, Primitive(Int) -> lhs_java ^ "*" ^ rhs_java, Primitive(Float)

	| Primitive(Int), Div, Primitive(Int) -> lhs_java ^ "/" ^ rhs_java, Primitive(Int)
	| Primitive(Float), Div, Primitive(Float)
	| Primitive(Int), Div, Primitive(Float)
	| Primitive(Float), Div, Primitive(Int) -> lhs_java ^ "/" ^ rhs_java, Primitive(Float)
	
    | x, Assign, y when x=y -> requires_assignable isAssignable; lhs_java ^ "=" ^ rhs_java, x
    
	| Primitive(String), AddAsn, Primitive(String) ->
                requires_assignable isAssignable;
				lhs_java ^ "+=" ^ rhs_java, Primitive(String)
                
    | Table(ttype), AddAsn, Singleton(rtype) when ttype=rtype ->                       
                requires_assignable isAssignable;
                lhs_java^".addRow("^rhs_java^")", Table(ttype)
    | Table(ttype), AddAsn, Table(rtype) when ttype=rtype ->
                requires_assignable isAssignable;
                lhs_java^".append("^rhs_java^")", Table(ttype)
				
	| Primitive(Int), AddAsn, Primitive(Int) -> 
                requires_assignable isAssignable;
                lhs_java ^ "+=" ^ rhs_java, Primitive(Int)
	| Primitive(Float), AddAsn, Primitive(Float)
	| Primitive(Int), AddAsn, Primitive(Float)
	| Primitive(Float), AddAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "+=" ^ rhs_java, Primitive(Float)
    
	| Primitive(Int), SubAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "-=" ^ rhs_java, Primitive(Int)
	| Primitive(Float), SubAsn, Primitive(Float)
	| Primitive(Int), SubAsn, Primitive(Float)
	| Primitive(Float), SubAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "-=" ^ rhs_java, Primitive(Float)
	
	| Primitive(Int), MultAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "*=" ^ rhs_java, Primitive(Int)
	| Primitive(Float), MultAsn, Primitive(Float)
	| Primitive(Int), MultAsn, Primitive(Float)
	| Primitive(Float), MultAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "*=" ^ rhs_java, Primitive(Float)

	| Primitive(Int), DivAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "/=" ^ rhs_java, Primitive(Int)
	| Primitive(Float), DivAsn, Primitive(Float)
	| Primitive(Int), DivAsn, Primitive(Float)
	| Primitive(Float), DivAsn, Primitive(Int) ->
                requires_assignable isAssignable;
                lhs_java ^ "/=" ^ rhs_java, Primitive(Float)
	
    | Primitive(Bool), AndAsn, Primitive(Bool) -> 
                requires_assignable isAssignable;
                lhs_java ^ "&=" ^ rhs_java, Primitive(Bool)
	| Primitive(Bool), OrAsn, Primitive(Bool) ->
                requires_assignable isAssignable;
                lhs_java ^ "|=" ^ rhs_java, Primitive(Bool)

    
	| Primitive(Int), Equal, Primitive(Int) 
	| Primitive(Float), Equal, Primitive(Int)
	| Primitive(Int), Equal, Primitive(Float)
	| Primitive(Float), Equal, Primitive(Float) 
	| Primitive(Bool), Equal, Primitive(Bool) 	-> lhs_java ^ "==" ^ rhs_java, Primitive(Bool)
	
	| Primitive(String), Equal, Primitive(String) -> lhs_java ^ ".equals(" ^ rhs_java ^ ")", Primitive(Bool)
	
	
	| Primitive(Int), Neq, Primitive(Int) 
	| Primitive(Float), Neq, Primitive(Int)
	| Primitive(Int), Neq, Primitive(Float)
	| Primitive(Float), Neq, Primitive(Float) 
	| Primitive(Bool), Neq, Primitive(Bool) 	-> lhs_java ^ "!=" ^ rhs_java, Primitive(Bool)
	
	| Primitive(String), Neq, Primitive(String) -> "!(" ^ lhs_java ^ ".equals(" ^ rhs_java ^ "))", Primitive(Bool)
	
	| Primitive(Int), Less, Primitive(Int) 
	| Primitive(Float), Less, Primitive(Int)
	| Primitive(Int), Less, Primitive(Float)
	| Primitive(Float), Less, Primitive(Float) -> lhs_java ^ "<" ^ rhs_java, Primitive(Bool)
	
	| Primitive(Int), Leq, Primitive(Int) 
	| Primitive(Float), Leq, Primitive(Int)
	| Primitive(Int), Leq, Primitive(Float)
	| Primitive(Float), Leq, Primitive(Float) -> lhs_java ^ "<=" ^ rhs_java, Primitive(Bool)
	
	| Primitive(Int), Geq, Primitive(Int) 
	| Primitive(Float), Geq, Primitive(Int)
	| Primitive(Int), Geq, Primitive(Float)
	| Primitive(Float), Geq, Primitive(Float) -> lhs_java ^ ">=" ^ rhs_java, Primitive(Bool)
	
	| Primitive(Int), Greater, Primitive(Int) 
	| Primitive(Float), Greater, Primitive(Int)
	| Primitive(Int), Greater, Primitive(Float)
	| Primitive(Float), Greater, Primitive(Float) -> lhs_java ^ ">" ^ rhs_java, Primitive(Bool)
        
	| Primitive(Bool), And, Primitive(Bool) -> lhs_java ^ "&&" ^ rhs_java, Primitive(Bool)
	| Primitive(Bool), Or, Primitive(Bool) -> lhs_java ^ "||" ^ rhs_java, Primitive(Bool)
	
	
    | Primitive(Bool), Qmark, Singleton(udt) ->
                lhs_java ^ " ? " ^ rhs_java ^ " : null", Singleton(udt)
    | Primitive(Bool), Qmark, Table(udt) ->
                lhs_java ^ " ? " ^ rhs_java ^ " : null", Table(udt)
    
	| lhs, op, rhs -> raise (Error ("Type mismatch: "
        ^ (string_of_lmtype lhs)
        ^ " and "
        ^ (string_of_lmtype rhs)
        ))

let java_of_function_call ns fn args = match (fn, args) with

      "print", [(printable_java, _)] ->
            "System.out.println("^printable_java^")", Void
		| "print", [] -> "System.out.println(\"\")", Void
    | "print", _ -> raise (Error "Print needs exactly one argument")

    | "commit", [(object_java, Table(t)); (filename_java, Primitive(String))] -> 
						"CsvInterpreter.toFile(WorkingDir.getPath("^filename_java^"), "^object_java^")", Table(t)
    | "commit", [(object_java, Singleton(t)); (filename_java, Primitive(String))] ->
            "CsvInterpreter.toFile(WorkingDir.getPath("^filename_java^"), "^object_java^")", Singleton(t)
    | "commit", _ -> raise (Error "Commit needs a Table or Singleton and filename")

    (* th of, as in 4.th(users), or, index.th(users) *)
    | "th", [(index_java, Primitive(Int)); (table_java, Table(udt))] ->
            table_java ^ ".nth(" ^ index_java ^ ")", Singleton(udt)
    | "th", _ -> raise (Error "nth needs a Table and index")

    | "size", [table_java, Table(_)] -> table_java ^ ".mySize()", Primitive(Int)
    | "size", _ -> raise (Error "size needs exactly one Table argument")
    
    | "stdin", [] -> "input.nextLine()", Primitive(String)									
    | "stdin", _ -> raise (Error "Stdin takes no arguments")

    | "setWorkingDir", [dir_java, Primitive(String)] ->	"WorkingDir.setPath("^dir_java^")", Void
    | "setWorkingDir", [] -> "WorkingDir.defaultPath()", Void				
    | "setWorkingDir", _ -> raise (Error "WorkingDir takes atmost one String argument")

    | "substring", [(jstring, Primitive(String)); (jstart, Primitive(Int))] ->
            jstring^".substring("^jstart^")", Primitive(String)
    | "substring", [(jstring, Primitive(String)); (jstart, Primitive(Int)); (jend, Primitive(Int))] ->
            jstring^".substring("^jstart^", "^jend^")", Primitive(String)
    | "substring", _ -> 
            raise (Error "Substring takes a string, a start index and optional end index")
    
    | "strlen", [string_java, Primitive(String)] ->
            string_java^".length()", Primitive(Int)
    | "strlen", _ -> raise (Error "Strlen takes exactly one string argument")
                
    | "charAt", [(string_java, Primitive(String)); (index_java, Primitive(Int))] -> 
            "String.valueOf("^string_java^".charAt("^index_java^"))", Primitive(String)
    | "charAt", _ -> raise (Error "StrCharAt takes one string and index argument")

		| "system", [(string_java, Primitive(String))] ->
						"RtUtil.System("^string_java^")", Primitive(String)
		| "system", _ -> raise (Error "System takes one string argument")
		
		| "delete", [(table_java, Table(ttype)); (record_java, Singleton(rtype))] when ttype = rtype -> 
							table_java^".delete("^record_java^")", Table(ttype)
		| "delete", _ -> raise (Error "Delete takes one table and one record argument")
		
		| "argc", [] -> "globArgs.length", Primitive(Int)
		
		| "argc", _ -> raise (Error "argc takes no arguments")
		
		| "argv", [(jindex, Primitive(Int))] -> "globArgs["^jindex^"]", Primitive(String)
		
		| "argv", _ -> raise (Error "argv takes one integer argument")
		
		| "tl", [(object_java, Table(t))] -> object_java^".tail()", Table(t)
		
		| "tl", _ -> raise (Error "tail takes one table as an argument")


	(* this needs to be last, it's a catch all if the function is not any of the builtins *)
    | fn, args ->
        let argtypes = (List.map snd args) in
        try
            let (_, javaname), rettype, fn_args = funcsig_of_name ns fn in
            if not ( fn_args = argtypes ) then
                raise (Error ("wrong argument types for "^fn))
            else
            let jcall = javaname^"("^(String.concat ", " (List.map fst args))^")" in
            jcall, rettype
        with Namespace.Error(_) -> try (* if there isn't a function fn, maybe it's a ctor *)
            let udt = udt_of_name ns fn in
            let (_, udt_jname), members = udt in
            let fsig = (List.map (fun (colname, coltype) -> Primitive(coltype)) members) in
            if fsig = argtypes then
                "new Record("^udt_jname^", "^
                    (String.concat ", " (List.map
                        (fun (argjava, argtype) -> "new Data("^argjava^")")
                        args)
                ^")"), Singleton(UDT(udt))
            else (match args with 
              [tuple_expr_java, Table(TupleUDT(udtlist))] when List.mem udt udtlist -> 
              
                tuple_expr_java^".getReg("^udt_jname^")", Table(UDT(udt))

            | [tuple_expr_java, Singleton(TupleUDT(udtlist))] when List.mem udt udtlist ->
                
                tuple_expr_java^".getReg("^udt_jname^")", Singleton(UDT(udt))
            
            | _ -> raise (Error ("wrong parameters for constructor."
                ^ (string_of_list string_of_lmtype argtypes)
                ^ "\nvs actual constructor\n"
                ^ (string_of_lmudt udt)
                ))
            )
        with Namespace.Error(_) -> raise (Error ("no function named "^fn))
			
let java_of_cast expr_java from_type to_type = 
    (match (to_type, from_type) with
          Primitive(x), Primitive(y) when x=y -> expr_java
        | Primitive(Int), Primitive(Float) -> "(int)"^expr_java
        | Primitive(Float), Primitive(Int) -> "(double)"^expr_java

        | Primitive(Int), Primitive(String) -> "Integer.parseInt("^expr_java^")"
        | Primitive(Float), Primitive(String) -> "Double.parseDouble("^expr_java^")"
        | Primitive(Bool), Primitive(String) -> "Boolean.getBoolean("^expr_java^")"
    
        | Primitive(String), Primitive(_) -> "\"\"+"^expr_java
				
        | Table(x), Singleton(y) when x=y -> "new Table("^expr_java^")"

        | _, _ -> raise (Error "cast between two incompatible types")
    ), to_type

    
