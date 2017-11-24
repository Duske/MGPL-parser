grammar MGPL;
options { backtrack=false; }
	
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};	
	
NUMBER
	:	( '0' | ('1'..'9') ('0'..'9')* );	
IDF	
	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;

Op	
	:	'||' | '&&' | '==' | '<' | '<=' | '+' | '-' | '*' | '/';

prog
	: 'game' IDF '(' attrasslist ? ')' decl* stmtblock block*;

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
	:	| ',' attrasslist;	

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
	:	'if (' expr ')' stmtblock '(' 'else' stmtblock ')'?;
	
forstmt
	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock;	
	
stmt:	ifstmt | forstmt | assstmt ';';	

assstmt
	:	var '=' expr;

var
	:	IDF var2;
	
var2 
	:	| '[' expr ']' var3 | '.' IDF;

var3
	:	| '.' IDF;
	
expr
	:	(NUMBER | var expr2 | '-'expr | '!'expr | '('expr')') (Op expr)*;

expr2
	:	| 'touches' var;
	
// Whitespace -- ignored
WS : (' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; } ; // or
// WS : (' '|'\r'|'\t'|'\u000C'|'\n') { skip(); } ;