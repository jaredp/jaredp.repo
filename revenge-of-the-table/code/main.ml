(*Michael Vitrano and Jared Pochtar*)

open Pp
open Ast

type compiler_options = {
    debug_parser : bool;
    main_class_name : string;
  }

let default_options = { 
    debug_parser = false;
    main_class_name = "Main"
  }

let options_from_flags flags = 
    let rec options last = function
          [] -> last
        | "-showparse"::rs ->
            options { last with debug_parser = true } rs
        | "-mainclass"::mainclassname::rs ->
            options { last with main_class_name = mainclassname } rs
        | _::rs -> options last rs
    in options default_options flags

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let program = Parser.program (Scanner.buffer_tokens Scanner.token) lexbuf in

  let compiler_parameters = options_from_flags (Array.to_list Sys.argv) in

  if compiler_parameters.debug_parser then
    print_endline (Pp.string_of_program program)
  else
    print_endline (Translator.java_of_program compiler_parameters.main_class_name program)
