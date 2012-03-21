{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"			{ multiComment lexbuf }      (* Multi Line Comments *)
| "//"			{ singleComment lexbuf }     (*Single Line Comments *)

| "type"   { TYPE }
| '='      { EQ }
| "and"	   { AND }

| "of"	   { OF }
| '|'	   { OR }

| '('      { LPAREN }
| '*'      { TUPLEATOR }
| ')'      { RPAREN }

| '{'      { LBRACE }
| ':'      { COLON }
| ';'      { SEMI }
| '}'      { RBRACE }

| "list"   { LIST }
| "option" { OPTION }

| ['a'-'z']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']* as lxm { ID(lxm) }
| ['A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']* as lxm { OID(lxm) }

| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and multiComment = parse
  "*/" { token lexbuf }
| _    { multiComment lexbuf }

and singleComment = parse
  "\n" { token lexbuf }
| _    { singleComment lexbuf }
