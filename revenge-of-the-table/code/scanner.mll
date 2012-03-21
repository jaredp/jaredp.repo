(*Michael Vitrano and Jared Pochtar*)

{

open Parser 

type string_interpolation_buffer_item =
    StrLiteral of string
  | Interpolation of token list

let buffer_tokens lexer =
	let tbuf = ref [] in
	let rec scanner_wrapper lexbuf = (match !tbuf with
		  [] ->
			(match lexer lexbuf with
				TOKENBUFFER(tokens) -> 
					tbuf := tokens;
					scanner_wrapper lexbuf
			  | t -> t
			)
		| t::rs ->
			tbuf := rs;
			t
	) in scanner_wrapper

let lex_to_buffer lexer lexbuf =
	let rec accum_lex prev = (
		match lexer lexbuf with
			None -> prev
		  | Some(tok) -> accum_lex (tok::prev)
	) in List.rev (accum_lex [])
        
let lex_ending_on endtok lexer =
    fun lexbuf -> 
        let next_tok = lexer lexbuf in
        if next_tok = endtok then EOF
        else next_tok

}

let id = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']*

rule string_literal = parse
  '"'								  	{ None }
| ([^'"' '\\' '$'])* as lxm             { Some(STRINGLITERAL(lxm))  }
| "\\$"								  	{ Some(STRINGLITERAL("$"))  }
| "\\n"								  	{ Some(STRINGLITERAL("\n")) }
| "\\\""								{ Some(STRINGLITERAL("\"")) }
| "\\\\"								{ Some(STRINGLITERAL("\\")) }
| '\\'(_ as escapechar) 				{ 
		raise (Failure("illegal escape code " ^ Char.escaped escapechar))
	}
| '$'(id as v)                          { Some(INTERPOLATION(Ast.Id(v))) }
| "${"									{ 
        try
            let expr = Parser.expr (buffer_tokens (lex_ending_on RBRACE token)) lexbuf
            in Some(INTERPOLATION(expr))
        with e -> raise (Failure "error parsing a string interpolation")
	}


and token = parse
  [' ' '\t' '\r'] 	{ token lexbuf } (* Whitespace *)
| "/*"				{ multiComment 0 lexbuf }      (* Multi Line Comments *)
| "//"				{ singleComment lexbuf }     (*Single Line Comments *)

| '\n'     { NEWLINE }
| ",\n"	   { token lexbuf }

| '"' 	   { TOKENBUFFER(lex_to_buffer string_literal lexbuf) }
| "\"\""   { STRINGLITERAL("") }

| "true"   { BOOLLITERAL(true) }
| "false"  { BOOLLITERAL(false) }
| "void"   { VOID }
| "null"   { NULL }

| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| '['      { LBRACK }
| ']'      { RBRACK }
| '#'      { HASH }
| ','      { COMMA }

| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }

| "&&"     { AND }
| "||"     { OR }
| "and"    { AND }
| "or"     { OR }

| '='      { ASSIGN }
| "+="     { PLUSEQ }
| "-="     { MINUSEQ }
| "*="     { TIMESEQ }
| "/="     { DIVIDEEQ }
| "&&="    { ANDEQ }
| "||="    { OREQ }

| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| '|'      { ITER }
| ':'      { COLON }
| ';'	   { SEMI }
| '.'      { DOT }
| '@'      { AT }
| '!'      { BANG }
| "|+|"	   { COLUMNAPPEND }
| '?'      { QMARK }

| "string" { STRING }
| "float"  { FLOAT }
| "bool"   { BOOL }
| "table"  { TABLE }
| "type"   { TYPE }
| "if"     { IF }
| "else"   { ELSE }
| "for"    { FOR }
| "do"	   { DO }
| "while"  { WHILE }
| "return" { RETURN }
| "int"    { INT }
| ['0'-'9']+'.'['0'-'9']* as lxm { FPLITERAL(float_of_string lxm) }
| ['0'-'9']+ as lxm { INTLITERAL(int_of_string lxm) }
| id as lxm { ID(lxm) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and multiComment level = parse
  "*/" { if level = 0 then token lexbuf
		  else multiComment (level-1) lexbuf }
| "/*" { multiComment (level+1) lexbuf }
| eof  { raise (Failure "file ends in a comment") }
| _    { multiComment level lexbuf }

and singleComment = parse
  "\n" { NEWLINE }
| _    { singleComment lexbuf }
