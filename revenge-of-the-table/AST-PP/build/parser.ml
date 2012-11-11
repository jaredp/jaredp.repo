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

open Parsing;;
# 1 "parser.mly"
 open Ast 
# 27 "parser.ml"
let yytransl_const = [|
  257 (* TYPE *);
  258 (* EQ *);
  259 (* AND *);
  260 (* OF *);
  261 (* OR *);
  262 (* LPAREN *);
  263 (* TUPLEATOR *);
  264 (* RPAREN *);
  265 (* LBRACE *);
  266 (* COLON *);
  267 (* SEMI *);
  268 (* RBRACE *);
  269 (* LIST *);
  270 (* OPTION *);
  271 (* REF *);
  272 (* OPEN *);
  273 (* EXCEPTION *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
  274 (* ID *);
  275 (* OID *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\001\000\001\000\002\000\002\000\004\000\004\000\
\004\000\004\000\005\000\005\000\006\000\006\000\003\000\003\000\
\007\000\008\000\008\000\009\000\009\000\009\000\009\000\009\000\
\000\000"

let yylen = "\002\000\
\000\000\002\000\003\000\003\000\004\000\005\000\003\000\004\000\
\001\000\001\000\003\000\005\000\001\000\003\000\001\000\003\000\
\001\000\001\000\003\000\001\000\002\000\002\000\002\000\003\000\
\002\000"

let yydefred = "\000\000\
\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\004\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\
\000\000\020\000\013\000\005\000\000\000\010\000\000\000\000\000\
\016\000\000\000\000\000\000\000\000\000\000\000\000\000\021\000\
\022\000\023\000\006\000\024\000\000\000\000\000\007\000\014\000\
\000\000\011\000\008\000\000\000\000\000\012\000"

let yydgoto = "\002\000\
\003\000\007\000\019\000\020\000\029\000\021\000\022\000\023\000\
\024\000"

let yysindex = "\006\000\
\000\000\000\000\003\255\249\254\005\255\009\255\011\255\027\255\
\000\000\026\255\000\000\014\255\007\255\255\254\031\255\255\254\
\016\255\000\000\000\000\000\000\032\255\000\000\029\255\251\254\
\000\000\007\255\030\255\033\255\010\255\009\255\255\254\000\000\
\000\000\000\000\000\000\000\000\255\254\250\254\000\000\000\000\
\251\254\000\000\000\000\034\255\255\254\000\000"

let yyrindex = "\000\000\
\000\000\000\000\039\000\000\000\000\000\000\000\015\000\000\000\
\000\000\052\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\047\000\000\000\035\000\001\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\018\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\253\255\014\000\000\000\000\000\242\255\000\000\
\010\000"

let yytablesize = 325
let yytable = "\025\000\
\018\000\027\000\011\000\004\000\016\000\043\000\001\000\032\000\
\033\000\034\000\008\000\044\000\016\000\012\000\002\000\017\000\
\018\000\019\000\005\000\006\000\038\000\039\000\042\000\009\000\
\018\000\010\000\040\000\010\000\013\000\014\000\046\000\015\000\
\026\000\028\000\017\000\031\000\030\000\036\000\025\000\035\000\
\041\000\000\000\037\000\045\000\000\000\000\000\009\000\000\000\
\000\000\000\000\000\000\015\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\018\000\000\000\018\000\000\000\018\000\000\000\018\000\
\018\000\000\000\000\000\018\000\018\000\000\000\000\000\002\000\
\018\000\018\000\019\000\000\000\019\000\000\000\019\000\000\000\
\019\000\019\000\000\000\000\000\019\000\019\000\002\000\002\000\
\000\000\019\000\019\000\017\000\000\000\017\000\000\000\017\000\
\000\000\000\000\017\000\000\000\000\000\017\000\017\000\009\000\
\000\000\009\000\017\000\017\000\015\000\000\000\015\000\000\000\
\015\000\000\000\000\000\000\000\000\000\000\000\009\000\009\000\
\000\000\000\000\000\000\015\000\015\000"

let yycheck = "\014\000\
\000\000\016\000\006\000\001\001\006\001\012\001\001\000\013\001\
\014\001\015\001\018\001\018\001\006\001\003\001\000\000\009\001\
\018\001\000\000\016\001\017\001\011\001\012\001\037\000\019\001\
\018\001\019\001\030\000\019\001\002\001\004\001\045\000\018\001\
\002\001\018\001\000\000\007\001\005\001\008\001\000\000\026\000\
\031\000\255\255\010\001\010\001\255\255\255\255\000\000\255\255\
\255\255\255\255\255\255\000\000\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\255\255\003\001\255\255\005\001\255\255\007\001\
\008\001\255\255\255\255\011\001\012\001\255\255\255\255\001\001\
\016\001\017\001\001\001\255\255\003\001\255\255\005\001\255\255\
\007\001\008\001\255\255\255\255\011\001\012\001\016\001\017\001\
\255\255\016\001\017\001\001\001\255\255\003\001\255\255\005\001\
\255\255\255\255\008\001\255\255\255\255\011\001\012\001\001\001\
\255\255\003\001\016\001\017\001\001\001\255\255\003\001\255\255\
\005\001\255\255\255\255\255\255\255\255\255\255\016\001\017\001\
\255\255\255\255\255\255\016\001\017\001"

let yynames_const = "\
  TYPE\000\
  EQ\000\
  AND\000\
  OF\000\
  OR\000\
  LPAREN\000\
  TUPLEATOR\000\
  RPAREN\000\
  LBRACE\000\
  COLON\000\
  SEMI\000\
  RBRACE\000\
  LIST\000\
  OPTION\000\
  REF\000\
  OPEN\000\
  EXCEPTION\000\
  EOF\000\
  "

let yynames_block = "\
  ID\000\
  OID\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    Obj.repr(
# 21 "parser.mly"
                            ( [] )
# 217 "parser.ml"
               : Ast.all_types))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Ast.all_types) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 't) in
    Obj.repr(
# 22 "parser.mly"
                            ( _1 @ _2 )
# 225 "parser.ml"
               : Ast.all_types))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.all_types) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'option) in
    Obj.repr(
# 23 "parser.mly"
                            ( _1 )
# 233 "parser.ml"
               : Ast.all_types))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Ast.all_types) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 24 "parser.mly"
                            ( _1 )
# 241 "parser.ml"
               : Ast.all_types))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 't_body) in
    Obj.repr(
# 27 "parser.mly"
                     ( [{ t_name = _2; body = _4 }] )
# 249 "parser.ml"
               : 't))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 't) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 't_body) in
    Obj.repr(
# 28 "parser.mly"
                     ( { t_name = _3; body = _5 }::_1 )
# 258 "parser.ml"
               : 't))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'struct_member_list) in
    Obj.repr(
# 31 "parser.mly"
                                    ( Structure(List.rev _2) )
# 265 "parser.ml"
               : 't_body))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'struct_member_list) in
    Obj.repr(
# 32 "parser.mly"
                                        ( Structure(List.rev _2) )
# 272 "parser.ml"
               : 't_body))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'option_list) in
    Obj.repr(
# 33 "parser.mly"
                    ( Enum(_1) )
# 279 "parser.ml"
               : 't_body))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't_decl) in
    Obj.repr(
# 34 "parser.mly"
                ( T_inline(_1) )
# 286 "parser.ml"
               : 't_body))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't_decl) in
    Obj.repr(
# 37 "parser.mly"
                        ( [_1, _3] )
# 294 "parser.ml"
               : 'struct_member_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'struct_member_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 't_decl) in
    Obj.repr(
# 38 "parser.mly"
                                            ( (_3, _5)::_1 )
# 303 "parser.ml"
               : 'struct_member_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'option) in
    Obj.repr(
# 41 "parser.mly"
             ( [_1] )
# 310 "parser.ml"
               : 'option_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'option_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'option) in
    Obj.repr(
# 42 "parser.mly"
                         ( _3 :: _1 )
# 318 "parser.ml"
               : 'option_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 45 "parser.mly"
         ( _1, None )
# 325 "parser.ml"
               : 'option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't_decl) in
    Obj.repr(
# 46 "parser.mly"
                 ( _1, Some(_3) )
# 333 "parser.ml"
               : 'option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'tuple) in
    Obj.repr(
# 49 "parser.mly"
        ( match _1 with [p_type] -> p_type | tuple -> Tuple(List.rev tuple) )
# 340 "parser.ml"
               : 't_decl))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'primary_type) in
    Obj.repr(
# 52 "parser.mly"
                    ( [_1] )
# 347 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'tuple) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'primary_type) in
    Obj.repr(
# 53 "parser.mly"
                                ( _3 :: _1 )
# 355 "parser.ml"
               : 'tuple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 56 "parser.mly"
         ( Type_id(_1) )
# 362 "parser.ml"
               : 'primary_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'primary_type) in
    Obj.repr(
# 57 "parser.mly"
                     ( List(_1) )
# 369 "parser.ml"
               : 'primary_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'primary_type) in
    Obj.repr(
# 58 "parser.mly"
                      ( Option(_1) )
# 376 "parser.ml"
               : 'primary_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'primary_type) in
    Obj.repr(
# 59 "parser.mly"
                        ( Ref(_1) )
# 383 "parser.ml"
               : 'primary_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 't_decl) in
    Obj.repr(
# 60 "parser.mly"
                       ( _2 )
# 390 "parser.ml"
               : 'primary_type))
(* Entry types *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let types (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.all_types)