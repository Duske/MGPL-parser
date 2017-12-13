grammar MGPL;
options { backtrack=false; output=AST; }
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
	: 	'game' IDF '(' attrasslist ? ')' decl* stmtblock block*
			-> ^(GAME ^(SETTINGS attrasslist) ^(GLOBALS decl*) ^(INIT stmtblock) ^(CODE block*));

decl
	:	vardecl ';'! | objdecl ';'!;

vardecl
	:	'int' IDF init? -> ^(IDF 'int' init?) 
	| 'int' IDF '[' NUMBER ']' -> ^(IDF 'int' NUMBER)
	;

init
	:	'='! expr;

objdecl
	:	objtype IDF '(' attrasslist? ')' -> ^(IDF objtype ^(ARGUMENTS attrasslist?))
	| objtype IDF '[' NUMBER ']' -> ^(IDF objtype NUMBER);

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
	:	'animation' IDF '(' objtype IDF ')' stmtblock;

eventblock
	:	'on' keystroke stmtblock;

keystroke
	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

stmtblock
	:	'{'! stmt* '}'!;
	
ifstmt
	:	'if' '(' expr ')' stmtblock ('else' stmtblock)? -> ^(IF ^(CONDITION expr) ^(THEN stmtblock) ^(ELSE stmtblock));
	
forstmt
	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock -> ^(FOR_LOOP ^(CONDITION assstmt expr assstmt) ^(STATEMENTS stmtblock));	
	
stmt
	:	ifstmt | forstmt | assstmt ';'!;	

assstmt
	:	var '=' expr -> ^(ASSIGNMENT var ^(VALUE expr));

var
	:	IDF var2? -> ^(IDF var2?);
	
//Added EMPTY-Token
var2 
	:	
	'[' expr ']' var3? -> ^(INDEX expr var3?) 
	| var3;

//Added EMPTY-Token^
var3
	:	'.' IDF -> ^(PROPERTY IDF);
	
expr
	:   	orexpr;

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
	:	unop? expr2;
	
expr2 
	: 	var expr3 | NUMBER | '('! expr ')'!;

expr3
	:	| 'touches' var;
	
// Whitespace -- ignored
WS : (' '|'\r'|'\t'|'\u000C'|'\n') { $channel=HIDDEN; } ; // or
//WS : (' '|'\r'|'\t'|'\u000C'|'\n') { skip(); } ;
