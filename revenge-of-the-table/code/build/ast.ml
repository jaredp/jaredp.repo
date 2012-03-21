(*Michael Vitrano and Jared Pochtar*)

type op = Assign
        | Add | Sub | Mult | Div 
        | Equal | Neq | Less | Leq | Greater | Geq
        | And | Or | Qmark
        | AddAsn | SubAsn | MultAsn | DivAsn | AndAsn | OrAsn


type t =
    Int
  | Float
  | String
  | Bool
  | Void
  | Udt of string
  | Tuple of string list

type var_decl = {
    vname : string;
    vtype : t;
    isTable : bool;
  }

type type_decl = {
    tname : string;
    members : var_decl list
  }

type col_access_id = string option * string

type expr =
    Id of string
  | Binop of expr * op * expr
  | Attr of expr * col_access_id
  | CurrentVar
  | Call of string * expr list
  | Cast of t * expr
  | CastToTable of expr
  | First of expr
  | Noexpr
  | StringLiteral of string
  | IntLiteral of int
  | BoolLiteral of bool
  | FPLiteral of float
  | Null of t * bool
  | Join of expr * expr * expr
  | Filter of expr * expr


type stmt =
    Block of block_line list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt
  | DoWhile of stmt * expr * stmt
  | Iter of string * expr * stmt
and block_line = 
    Statement_line of stmt
  | Vdecl_line of var_decl
  
type func_decl = {
    ret_table : bool;
    rettype : t;
    fname : string;
    formals : var_decl list;
    body : stmt;
  }

type program = {
    global_vars : var_decl list;
    functions : func_decl list;
    types : type_decl list;
    global_code : stmt list
  }

type table_literal = expr list list
