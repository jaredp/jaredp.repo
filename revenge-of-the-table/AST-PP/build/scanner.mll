{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf }     (* Whitespace *)
| "(*"                 { comment 0 lexbuf } (* Comments *)

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
| "ref"    { REF }

| "let"         { nontype lexbuf }
| "open"        { OPEN }
| "exception"   { EXCEPTION }

| ['a'-'z']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']* as lxm { ID(lxm) }
| ['A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_' '\'']* as lxm { OID(lxm) }

| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment level = parse
  "(*" { comment (level+1) lexbuf }
| "*)" { if level = 0 then token lexbuf
		  else comment (level-1) lexbuf }
| eof  { EOF }
| _    { comment level lexbuf }

and nontype = parse
  "\ntype"	{ TYPE }
| "(*"      { nontype_comment 0 lexbuf }
| eof		{ EOF }
| _			{ nontype lexbuf }

and nontype_comment level = parse
  "(*" { nontype_comment (level+1) lexbuf }
| "*)" { if level = 0 then nontype lexbuf
		  else nontype_comment (level-1) lexbuf }
| eof  { EOF }
| _    { nontype_comment level lexbuf }

