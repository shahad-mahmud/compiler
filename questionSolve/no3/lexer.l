%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}

digit     "0"[0-1]

%%
[ \t\r\f]+      {}
{digit}         { yylval.int_val   = atoi(yytext); return BINARY; }
"\n"            { lineno += 1; }
.               { yyerror("Unrecognized character"); }
%%
