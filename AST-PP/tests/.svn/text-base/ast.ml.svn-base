
type t_decl = Type_id of string | Tuple of t_decl list | List' of t_decl | Option' of t_decl

type structure = (string * t_decl) list
  
type enum = (string * (t_decl option)) list
  
type t_body = Structure of structure | Enum of enum | T_inline of t_decl

type t = {
    t_name : string;
	body : t_body;
  }
  
type all_types = t list
