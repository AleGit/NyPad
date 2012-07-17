grammar Nyaya;

options{
	language=ObjC;
	output=AST;
	ASTLabelType = CommonTree;
}

/*
tokens{
	PREDICATE;
	FUNCTION;
}
*/

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

condition: formula EOF! ;

formula	
	:	junction (IMPLIES^ formula)?; 

junction
	:	negation ((OR^ | AND^) negation)* ;

negation 
	:	NOT^? (term | (LPAREN! formula RPAREN!)) ;

term	:	function | IDENTIFIER ;

function:	IDENTIFIER functionTuple;

functionTuple
	:	LPAREN! (formula) (','! formula )* RPAREN!;

/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

LPAREN : '(' ;
RPAREN :  ')' ;
IMPLIES : '>' ;
AND :  '&' ;
OR :  '|' ;
NOT :  '!' ;

IDENTIFIER : (('a'..'z') | ('0'..'9')) CHARACTER* ;

VARIABLE : '?' (('a'..'z') | ('0'..'9')) CHARACTER* ;

CONSTANT: (('a'..'z') | ('A'..'Z')) CHARACTER* ;

fragment CHARACTER: ('0'..'9' | 'a'..'z' | 'A'..'Z' | '_') ;

WS : (' ' | '\t' | '\r' | '\n')+ {$channel = HIDDEN ;} ;
