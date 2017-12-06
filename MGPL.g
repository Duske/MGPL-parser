grammar MGPL;
options { backtrack=false; }

COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};	
	
NUMBER
	:	( '0' | ('1'..'9') ('0'..'9')* );	
	
IDF	
	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;

orop
	:	'||';

andop
	:	'&&';

mulop
	:	'*' | '/';

addop
	:	'+' | '-' ;

relop
	:	'==' | '<' | '<=';

unop	
	:	'!' | '-';

prog
	: 	'game' IDF '(' attrasslist ? ')' decl* stmtblock block*;

decl
	:	vardecl ';' | objdecl ';';

vardecl
	:	'int' IDF init ? | 'int' IDF '[' NUMBER ']';

init
	:	'=' expr;

objdecl
	:	objtype IDF '(' attrasslist ? ')' | objtype IDF '[' NUMBER ']';

objtype
	:	'rectangle' | 'triangle' | 'circle';

attrasslist
	:	attrass attrasslist2;
	
attrasslist2
	:	| ',' attrasslist;	

attrass
	:	IDF '=' expr;

block
	:	animblock | eventblock;

animblock
	:	'animation' IDF '(' objtype IDF ')' stmtblock;

eventblock
	:	'on' keystroke stmtblock;

keystroke
	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

stmtblock
	:	'{' stmt* '}';
	
ifstmt
	:	'if (' expr ')' stmtblock elsestmt?;
	
elsestmt
	:	'else' stmtblock;
	
forstmt
	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock;	
	
stmt
	:	ifstmt | forstmt | assstmt ';';	

assstmt
	:	var '=' expr;

var
	:	IDF var2;
	
var2 
	:	| '[' expr ']' var3 | '.' IDF;

var3
	:	| '.' IDF;

expr
	:   	orexpr;

orexpr
	:	andexpr (orop andexpr)*;
	
andexpr
	:	relexpr (andop relexpr)*;

relexpr
	:	addexpr (relop addexpr)*;

addexpr
	:	mulexpr (addop mulexpr)*;
	
mulexpr
	:	unexpr (mulop unexpr)*;
	
unexpr
	:	unop? expr2;
	
expr2 
	: 	var expr3 | NUMBER | '(' expr ')';

expr3
	:	| 'touches' var;
	
// Whitespace -- ignored
//WS : (' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; } ; // or
WS : (' '|'\r'|'\t'|'\u000C'|'\n') { skip(); } ;