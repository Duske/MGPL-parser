grammar MGPL;
options { backtrack=false; output=AST; k=1;}
tokens { 
	GAME;
	SETTINGS;
	GLOBALS;
	CODE;
	STMTBLOCK;
	STATEMENTS;
	INIT;
	ARGUMENTS;
	ASSIGNMENT;
	FOR_LOOP;
	OBJECT;
	CONDITION;
	INDEX;
	IF;
	ELSE;
	PROPERTY;
	THEN;
	VALUE;
	AFTERTHOUGHT;
	FOR_INIT;
	ANIMATION;
	ARRAY;
	EVENTHANDLER;
}

COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};	
	
NUMBER
	:	('0' | ('1'..'9') ('0'..'9')* );	
	
IDF	
	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;

OROP
	:	'||';

ANDOP
	:	'&&';

MULOP
	:	'*' | '/';

addop
	:	'+' | MINUS;

RELOP
	:	'==' | '<' | '<=';

unop	
	:	'!' | MINUS;

MINUS
	:	'-';

prog
	: 	'game' IDF '(' attrasslist ? ')' decl* stmtblock? block*
			-> ^(GAME ^(SETTINGS attrasslist) ^(GLOBALS decl*) ^(INIT stmtblock?) ^(CODE block*));

decl
	:	vardecl ';'! | objdecl ';'!;

vardecl
	:	'int' IDF vardecl2? -> ^('int' IDF vardecl2?);

vardecl2
	:	init
	| '['! NUMBER ']'!;

init
	:	'='! expr;

objdecl
	:	objtype IDF objdecl2 -> ^(objtype IDF objdecl2);

objdecl2
	:	'(' attrasslist? ')' -> ^(ARGUMENTS attrasslist?)
	| '[' NUMBER ']' -> ^(ARRAY NUMBER);

objtype
	:	'rectangle' | 'triangle' | 'circle';

attrasslist
	:	attrass attrasslist2;
	
attrasslist2
	:	| ','! attrasslist;	

attrass
	:	IDF '=' expr -> ^(IDF expr);

block
	:	animblock | eventblock;

animblock
	:	'animation' i1=IDF '(' objtype i2=IDF ')' stmtblock -> ^(ANIMATION ^($i1 ^(ARGUMENTS objtype $i2 ) ^(STATEMENTS stmtblock)));

eventblock
	:	'on' keystroke stmtblock -> ^(EVENTHANDLER keystroke stmtblock);

keystroke
	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

stmtblock
	:	'{'! stmt* '}'!;
	
ifstmt
	:	'if' '(' expr ')' s1=stmtblock ('else' s2=stmtblock)? -> ^(IF ^(CONDITION expr) ^(THEN $s1) ^(ELSE $s2)?);
	
forstmt
	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock -> ^(FOR_LOOP ^(FOR_INIT assstmt ^(CONDITION expr) ^(AFTERTHOUGHT assstmt)) ^(STATEMENTS stmtblock));	
	
stmt
	:	ifstmt | forstmt | assstmt ';'!;	

assstmt
	:	var '=' expr -> ^(ASSIGNMENT var ^(VALUE expr));

var
	:	IDF var2? -> ^(IDF var2?);
	
var2 
	:	
	'[' expr ']' var3? -> ^(INDEX expr) var3? 
	| var3;

var3
	:	'.' IDF -> ^(PROPERTY IDF);
	
expr
	:   orexpr;

orexpr
	:	andexpr (OROP^ andexpr)*;
	
andexpr
	:	relexpr (ANDOP^ relexpr)*;

relexpr
	:	addexpr (RELOP^ addexpr)*;

addexpr
	:	mulexpr (addop^ mulexpr)*;
	
mulexpr
	:	unexpr (MULOP^ unexpr)*;
	
unexpr
	:	(unop^)? expr2;
	
expr2 
	: 	var expr3 | NUMBER | '('! expr ')'!;

expr3
	:	| 'touches' var;
	
// Whitespace -- ignored
WS : (' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; } ; // or
//WS : (' '|'\r'|'\t'|'\u000C'|'\n') { skip(); } ;
