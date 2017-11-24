grammar MGPL;
options { backtrack=false; }
/*@header {
	package antlr.example2;
}
@lexer::header {
	package antlr.example2;
}*/

start
	:	Prog EOF;		
Op	
	:	'||' | '&&' | '==' | '<' | '<=' | '+' | '-' | '*' | '/';
	
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};	
	
Number
	:	( '0' | ('1'..'9') ('0'..'9')* ) ;		

Chars
	: 	(('a'..'z') | ('A'..'Z'))+;
	
Idf	
	:	Chars(Chars|Number|'_')*;

Prog
	: 'game' Idf '(' AttrAssList ? ')' Decl* StmtBlock Block*;

Decl
	:	VarDecl ';' | ObjDecl ';';

VarDecl
	:	'int' Idf Init ? | 'int' Idf '[' Number ']';

Init
	:	'=' Expr;

ObjDecl
	:	ObjType Idf '(' AttrAssList ? ')' | ObjType Idf '[' Number ']';

ObjType
	:	'rectangle' | 'triangle' | 'circle';

AttrAssList
	:	AttrAss AttrAssList2;
	
AttrAssList2
	:	| ',' AttrAssList;	

AttrAss
	:	Idf '=' Expr;

Block
	:	AnimBlock | EventBlock;

AnimBlock
	:	'animation' Idf '(' ObjType Idf ')' StmtBlock;

EventBlock
	:	'on' KeyStroke StmtBlock;

KeyStroke
	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

StmtBlock
	:	'{' Stmt* '}';
	
IfStmt
	:	'if (' Expr ')' StmtBlock '(' 'else' StmtBlock ')'?;
	
ForStmt
	:	'for' '(' AssStmt ';' Expr ';' AssStmt ')' StmtBlock;	
	
Stmt:	IfStmt | ForStmt | AssStmt ';';	

AssStmt
	:	Var '=' Expr;

Var
	:	Idf Var2;
	
Var2 
	:	| '[' Expr ']' Var3 | '.' Idf;

Var3
	:	| '.' Idf;
	
Expr
	:	(Number | Var Expr2 | '-'Expr | '!'Expr | '('Expr')') (Op Expr)*;

Expr2
	:	| 'touches' Var;
	
// Whitespace -- ignored
WS : (' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; } ; // or
// WS : (' '|'\r'|'\t'|'\u000C'|'\n') { skip(); } ;