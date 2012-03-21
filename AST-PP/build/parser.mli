type token =
  | TYPE
  | EQ
  | AND
  | OF
  | OR
  | LPAREN
  | TUPLEATOR
  | RPAREN
  | LBRACE
  | COLON
  | SEMI
  | RBRACE
  | LIST
  | OPTION
  | REF
  | OPEN
  | EXCEPTION
  | ID of (string)
  | OID of (string)
  | EOF

val types :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.all_types
