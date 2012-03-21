
%{ open Ast %}

/* Michael Vitrano and Jared Pochtar */

%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA
%token VOID NULL
%token LBRACK RBRACK HASH COLUMNAPPEND QMARK
%token PLUS MINUS TIMES DIVIDE
%token ASSIGN PLUSEQ MINUSEQ TIMESEQ DIVIDEEQ ANDEQ OREQ
%token EQ NEQ LT LEQ GT GEQ AND OR
%token ITER
%token COLON DOT NEWLINE AT BANG
%token STRING INT TABLE TYPE BOOL
%token RETURN IF ELSE FOR DO WHILE FLOAT
%token <float> FPLITERAL
%token <int> INTLITERAL
%token <bool> BOOLLITERAL
%token <string> ID

%token <string> STRINGLITERAL
%token <Ast.expr> INTERPOLATION

%token <token list> TOKENBUFFER /* do not use inside parser! */

%token EOF

%nonassoc NOELSE
%nonassoc ELSE

%nonassoc QMARK

%left AND OR
%left EQ NEQ LT GT LEQ GEQ COLON
%right ASSIGN PLUSEQ MINUSEQ TIMESEQ DIVIDEEQ ANDEQ OREQ 
%left PLUS MINUS
%left TIMES DIVIDE

%left LBRACK RBRACK
%left COLUMNAPPEND

%nonassoc NO_DOT
%nonassoc DOT

%nonassoc BANG

%start program
%type <Ast.program> program

%start expr
%type <Ast.expr> expr

%%

program:
  program_  { {
		global_vars = List.rev $1.global_vars;
		functions = List.rev $1.functions;
		types = List.rev $1.types;
		global_code = List.rev $1.global_code
  } }

program_:
   /* nothing */	{ {global_vars = []; functions = []; types = []; global_code = [] } }
 | program_ NEWLINE	{ $1 }
 | program_ fdecl	{ {$1 with functions = ($2 :: $1.functions) } }
 | program_ tdecl	{ {$1 with types = ($2 :: $1.types) } }
 | program_ stmt	{ {$1 with global_code = ($2 :: $1.global_code) } }
 | program_ var_declaration NEWLINE 
    { {$1 with global_vars = ($2 :: $1.global_vars);
               (* automatically load tables from same-named csv file *)
               global_code = match $2.vtype, $2.isTable with
                    | Udt(udt_name), true ->
                        let defaultfileexpr = StringLiteral($2.vname^".csv") in
                        let load =  Call("load", [Id(udt_name); defaultfileexpr]) in
                        Expr(Binop(Id($2.vname), Assign, load))::$1.global_code
                    | _ -> $1.global_code    
    } }
 | program_ var_declaration ASSIGN expr NEWLINE 
    { {$1 with global_vars = ($2 :: $1.global_vars);
               global_code = Expr(Binop(Id($2.vname), Assign, $4))::$1.global_code } }

tdecl:
    TYPE ID LBRACE NEWLINE member_declaration_list RBRACE 
        { { tname = $2; members = List.rev $5 } }

member_declaration_list:
    /* nothing */       { [] }
  | member_declaration_list var_declaration NEWLINE { ($2 :: $1) }
  
var_declaration:
    fulltype ID        { { vname = $2; vtype = fst $1; isTable = snd $1 } }

fulltype:
    type_name           { $1, false }
  | type_name TABLE     { $1, true }

primitive_type_name:
    INT     { Int }
  | FLOAT   { Float }
  | STRING  { String }
  | BOOL    { Bool }
  | VOID    { Void }
  
type_name:
    primitive_type_name { $1 } 
  | ID                  { Udt ($1) }
  | tuple_type          { Tuple(List.rev $1) }

tuple_type:
	ID HASH ID			{ [$3; $1] }	//we're reversing it later
  | tuple_type HASH ID  { $3::$1 }


fdecl:
    fulltype ID LPAREN formals_opt RPAREN fdecl_body
     { { ret_table = snd $1;
		 rettype = fst $1;
         fname = $2;
		 formals = $4;
		 body = $6 } }
  | fulltype type_name DOT ID LPAREN formals_opt RPAREN fdecl_body
     { { ret_table = snd $1;
		 rettype = fst $1;
         fname = $4;
		 formals = {vname = "self"; vtype = $2; isTable = false} :: $6;
		 body = $8 } }

formals_opt:
    /* nothing */ { [] }
  | formal_list   { List.rev $1 }

formal_list:
    var_declaration						{ [$1] }
  | formal_list COMMA var_declaration	{ $3 :: $1 }

fdecl_body:
	block				{ $1 }
  | ASSIGN expr NEWLINE	{ Return($2) }

block:
    LBRACE block_line_list RBRACE	{ Block(List.rev $2) }

block_line_list:
    /* nothing */  { [] }
  | block_line_list stmt		{ Statement_line($2) :: $1 }
  | block_line_list	NEWLINE		{ $1 }
  | block_line_list var_declaration ASSIGN expr NEWLINE 
		{ Statement_line(Expr(Binop(Id($2.vname), Assign, $4))) :: Vdecl_line ($2) :: $1 }

stmt:
    expr NEWLINE								{ Expr($1) }
  | RETURN expr NEWLINE							{ Return($2) }
  | block										{ $1 }
  
  | IF LPAREN expr RPAREN stmt %prec NOELSE		{ If($3, $5, Block([])) }
  | IF LPAREN expr RPAREN stmt ELSE stmt		{ If($3, $5, $7) }

  | DO stmt WHILE LPAREN expr RPAREN stmt		{ DoWhile($2, $5, $7) }
  | DO WHILE LPAREN expr RPAREN stmt			{ DoWhile(Block([]), $4, $6) }
  | DO stmt WHILE LPAREN expr RPAREN NEWLINE	{ DoWhile($2, $5, Block([])) }
  
  | expr ITER ID COLON stmt						{ Iter($3, $1, $5) }
  | expr ITER ID LBRACE block_line_list RBRACE  
                                                { Iter($3, $1, Block(List.rev $5)) }
  | FOR LPAREN expr_opt SEMI expr_opt SEMI expr_opt RPAREN stmt
												{ For($3, $5, $7, $9) }

expr_opt:
    /* nothing */ { Noexpr }
  | expr          { $1 }

str_literal:
    STRINGLITERAL    			{ StringLiteral($1) }
  | INTERPOLATION               { Cast(String, $1) }
  | str_literal INTERPOLATION	{ Binop($1, Add, Cast(String, $2)) }
  | str_literal STRINGLITERAL	{ Binop($1, Add, StringLiteral($2)) }


expr:
    INTLITERAL         	{ IntLiteral($1) }
  | FPLITERAL        	{ FPLiteral($1) }
  | BOOLLITERAL      	{ BoolLiteral($1) }
  | str_literal    		{ $1 }
  
  | NULL fulltype       { Null(fst $2, snd $2) }
  
  | ID                  { Id($1) }
  | expr DOT col_name   { Attr($1, $3) }
  | AT                  { CurrentVar }
  | DOT col_name        { Attr(CurrentVar, $2) }
  | COLON ID            { 
        let lhs = Attr(Id("a"), (None, $2)) in
        let rhs = Attr(Id("b"), (None, $2)) in
        Binop(lhs, Equal, rhs)
    }

  | BANG expr                                   { First($2) }
  | TABLE COLON expr %prec NO_DOT               { CastToTable($3) }
  | primitive_type_name COLON expr %prec NO_DOT { Cast($1, $3) }
  
  | expr QMARK expr     { Binop($1, Qmark, $3) }
  | expr AND    expr 	{ Binop($1, And,   $3) }
  | expr OR     expr 	{ Binop($1, Or,    $3) }
  | expr PLUS   expr 	{ Binop($1, Add,   $3) }
  | expr MINUS  expr 	{ Binop($1, Sub,   $3) }
  | expr TIMES  expr 	{ Binop($1, Mult,  $3) }
  | expr DIVIDE expr 	{ Binop($1, Div,   $3) }
  
  | expr ANDEQ    expr 	{ Binop($1, AndAsn,   $3) }
  | expr OREQ     expr 	{ Binop($1, OrAsn,    $3) }
  | expr PLUSEQ   expr 	{ Binop($1, AddAsn,   $3) }
  | expr MINUSEQ  expr 	{ Binop($1, SubAsn,   $3) }
  | expr TIMESEQ  expr 	{ Binop($1, MultAsn,  $3) }
  | expr DIVIDEEQ expr 	{ Binop($1, DivAsn,   $3) }

  | expr EQ     expr	{ Binop($1, Equal, $3) }
  | expr COLON	expr 	{ Binop($1, Equal, $3) }
  | expr NEQ    expr 	{ Binop($1, Neq,   $3) }
  | expr LT     expr 	{ Binop($1, Less,  $3) }
  | expr LEQ    expr 	{ Binop($1, Leq,   $3) }
  | expr GT     expr 	{ Binop($1, Greater,  $3) }
  | expr GEQ    expr 	{ Binop($1, Geq,   $3) }
  | expr ASSIGN expr 	{ Binop($1, Assign, $3) }
  
  | ID LPAREN actuals_opt RPAREN { Call($1, $3) }
  | expr DOT ID LPAREN actuals_opt RPAREN { Call($3, $1::$5) }
  
  | LPAREN expr RPAREN { $2 }
  
  | expr LBRACK expr RBRACK			{ Filter($1, $3) }
  | expr LBRACK expr RBRACK expr	{ Join($1, $3, $5) }
  | expr COLUMNAPPEND expr
  	{ Join(CastToTable($1), BoolLiteral(true), CastToTable($3)) }
    
col_name:
    ID %prec NO_DOT     { None, $1 }
  | ID DOT ID           { Some($1), $3 }

actuals_opt:
    /* nothing */ { [] }
  | actuals_list  { List.rev $1 }

actuals_list:
    expr                    { [$1] }
  | actuals_list COMMA expr { $3 :: $1 }
