OBJS = ast.cmo pp.cmo parser.cmo scanner.cmo microc.cmo

microc : $(OBJS)
	ocamlc -o microc $(OBJS)

# bizzarre, probably macroifyable, just a prototype

ast.ml : ../ast.ml
	cat ../ast.ml > ast.ml

pp.ml : ../ast.ml ../../../build/ast-pp
	../../../build/ast-pp < ../ast.ml > pp.ml

microc.ml : ../microc.ml
	cat ../microc.ml > microc.ml

parser.mly : ../parser.mly
	cat ../parser.mly > parser.mly
	
scanner.mll : ../scanner.mll
	cat ../scanner.mll > scanner.mll

# now the normal stuff

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly

%.cmo : %.ml
	ocamlc -c $<

%.cmi : %.mli
	ocamlc -c $<

.PHONY : clean
clean :
	rm -f *.* microc

# Generated by ocamldep *.ml *.mli
ast.cmo: 
ast.cmx: 
microc.cmo: scanner.cmo parser.cmi ast.cmo pp.cmo
microc.cmx: scanner.cmx parser.cmx ast.cmx pp.cmo
parser.cmo: ast.cmo parser.cmi 
parser.cmx: ast.cmx parser.cmi 
scanner.cmo: parser.cmi 
scanner.cmx: parser.cmx 
parser.cmi: ast.cmo 
