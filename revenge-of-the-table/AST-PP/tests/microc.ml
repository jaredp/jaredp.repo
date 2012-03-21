open Ast

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let program = Parser.types Scanner.token lexbuf in
  print_endline (Pp.string_of_all_types program);
  