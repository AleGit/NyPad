grammar Nyaya;

options{
	language=ObjC;
	output=AST;
	ASTLabelType = CommonTree;
}

tokens{
	PREDICATE;
	FUNCTION;
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

condition: formula EOF! ;

formula	
	:	disjunction (IMPLIES^ disjunction)*;

disjunction
	:	conjunction (OR^ conjunction)* ;

conjunction
	:	negation (AND^ negation)* ;

negation 
	:	NOT^? LPAREN! formula RPAREN! ;

term	:	function | VARIABLE ;

function:	CONSTANT functionTuple -> ^(FUNCTION CONSTANT functionTuple)
	|	CONSTANT;

functionTuple
	:	LPAREN! (CONSTANT | VARIABLE) (','! (CONSTANT | VARIABLE) )* RPAREN!;

/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

LPAREN : '(' ;
RPAREN :  ')' ;
IMPLIES : '>' ;
AND :  '&' ;
OR :  '|' ;
NOT :  '!' ;

VARIABLE: '?' (('a'..'z') | ('0'..'9')) CHARACTER* ;

CONSTANT: (('a'..'z') | ('0'..'9')) CHARACTER* ;

PREPOSITION: ('A'..'Z') CHARACTER* ;

fragment CHARACTER: ('0'..'9' | 'a'..'z' | 'A'..'Z' | '_') ;

WS : (' ' | '\t' | '\r' | '\n')+ {$channel = HIDDEN ;} ;
