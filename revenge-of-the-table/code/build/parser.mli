type token =
  | SEMI
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | COMMA
  | VOID
  | NULL
  | LBRACK
  | RBRACK
  | HASH
  | COLUMNAPPEND
  | QMARK
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | ASSIGN
  | PLUSEQ
  | MINUSEQ
  | TIMESEQ
  | DIVIDEEQ
  | ANDEQ
  | OREQ
  | EQ
  | NEQ
  | LT
  | LEQ
  | GT
  | GEQ
  | AND
  | OR
  | ITER
  | COLON
  | DOT
  | NEWLINE
  | AT
  | BANG
  | STRING
  | INT
  | TABLE
  | TYPE
  | BOOL
  | RETURN
  | IF
  | ELSE
  | FOR
  | DO
  | WHILE
  | FLOAT
  | FPLITERAL of (float)
  | INTLITERAL of (int)
  | BOOLLITERAL of (bool)
  | ID of (string)
  | STRINGLITERAL of (string)
  | INTERPOLATION of (Ast.expr)
  | TOKENBUFFER of (token list)
  | EOF

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
val expr :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
