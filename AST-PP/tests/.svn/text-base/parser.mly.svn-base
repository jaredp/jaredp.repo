%{ open Ast %}

%token TYPE EQ AND
%token OF OR
%token LPAREN TUPLEATOR RPAREN 
%token LBRACE COLON SEMI RBRACE
%token LIST OPTION

%token <string> ID
%token <string> OID
%token EOF

%start types
%type <Ast.all_types> types

%%

types:
  /* nothing */ { [] }
| types	t		{ $1 @ $2 }
 
t:
  TYPE ID EQ t_body		{ [{ t_name = $2; body = $4 }] }
| t AND ID EQ t_body	{ { t_name = $3; body = $5 }::$1 }

t_body:
  LBRACE struct_member_list RBRACE		{ Structure(List.rev $2) }
| LBRACE struct_member_list SEMI RBRACE	{ Structure(List.rev $2) }
| option_list							{ Enum($1) }
| t_decl								{ T_inline($1) }

struct_member_list:
  ID COLON t_decl							{ [$1, $3] }
| struct_member_list SEMI ID COLON t_decl   { ($3, $5)::$1 }

option_list:
  option					{ [$1] }
| option_list OR option		{ $3 :: $1 }

option:
  OID				{ $1, None }
| OID OF t_decl		{ $1, Some($3) }

t_decl:
  tuple { match $1 with [p_type] -> p_type | tuple -> Tuple(List.rev tuple) }

tuple:
  primary_type						{ [$1] }
| tuple TUPLEATOR primary_type		{ $3 :: $1 }

primary_type:
  ID					{ Type_id($1) }
| primary_type LIST		{ List'($1) }
| primary_type OPTION	{ Option'($1) }
| LPAREN t_decl RPAREN	{ $2 }