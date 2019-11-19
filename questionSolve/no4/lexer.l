
%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "parser.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]

ID        {alpha}+{alnum}*
ICONST    "0"|[0-9]{digit}*
FCONST    "0"|{digit}*"."{digit}+
CCONST    (\'{print}\')|(\'\\[nftrbv]\')

%%

"//".*        { printf("Comment at line %d\n", lineno); } 

"int"       { return INT; }
"double"       { return FLOAT; }
"char"		{return CHAR;}

"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"continue"  { return CONTINUE; }
"break"     { return BREAK; }
"for"		{return FOR;}
"do"		{return DO;}
"+"       { return ADDOP; }
"-"       { return SUBOP; }
"*"       { return MULOP; }
"/"       { return DIVOP; }
"=="      { return EQUOP; }
"!="	  { return NTEQUOP; }
">"       { return GT;  }
"<"       { return LT;  }
">="	  { return GTE; }
"<="	  { return LTE; }
"++"	  {return INCR;}

"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }
"="       { return ASSIGN; }
"print"   { return PRINT; }
","		  { return COMMA;}


{ID}    {
		yylval.id = (list_t*)malloc(sizeof(list_t));
        strcpy(yylval.id->st_name, yytext);
        return ID;
        }
{ICONST}    { yylval.int_val   = atoi(yytext); return ICONST; }
{FCONST}    { yylval.float_val = atof(yytext); return FCONST; }
{CCONST}    { yylval.char_val  = yytext[0];    return CCONST; }




"\n"        { lineno += 1; }
[ \t\r\f]+  


.       { yyerror("Unrecognized character"); }

%%
