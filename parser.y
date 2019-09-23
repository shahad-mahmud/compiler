%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.c"
	#include "codeGen.h"
	#include "semantic.h"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
	int int_val;
	list_t* id;
}

%token<int_val> CHAR INT FLOAT DOUBLE IF ELSE DO WHILE FOR CONTINUE BREAK VOID RETURN PRINT
%token<int_val> ADDOP SUBOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP NEQUOP LT GT GTE LTE
%token<int_val> LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER APOSTOPH
%token <id> ID
%token <int_val> ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING

/*associavities*/
%left LPAREN RPAREN LBRACK RBRACK
%left MULOP DIVOP
%left ADDOP
%left LT GT LTE GTE
%left EQUOP NEQUOP
%left OROP
%left ANDOP
%left COMMA
%right ASSIGN
%right NOTOP INCR REFER

/*value type of non-terminals*/
%type <int_val>  declaration

%start program

%%
program: {gen_code(START, -1);} statements {gen_code(HALT, -1);} ;

statements: statements statement | ;

statement:    declarations;


declarations: 	  declarations declaration 
			  	| ;

declaration:    INT ID SEMI
						{
							list_t* el = search($2->st_name); 
							if(el == NULL){
								insert($2->st_name, strlen($2->st_name), INT_TYPE);
								$2->address = address-1;
								gen_code(STORE, address-1);
								printf("%s is declared successfully.\n\n", $2->st_name);
							}else{
								printf("%s is already declared.\n", el->st_name);
							}
						}
			  	| FLOAT ID SEMI
						{
							list_t* el = search($2->st_name); 
							if(el == NULL){
								insert($2->st_name, strlen($2->st_name), REAL_TYPE);
								$2->address = address-1;
								gen_code(STORE, address-1);
								printf("%s is declared successfully.\n\n", $2->st_name);
							}else{
								printf("%s is already declared.\n", el->st_name);
							}
						} 
			 	| CHAR ID SEMI
						{
							list_t* el = search($2->st_name); 
							if(el == NULL){
								insert($2->st_name, strlen($2->st_name), CHAR_TYPE);
								$2->address = address-1;
								gen_code(STORE, address-1);
								printf("%s is declared successfully.\n\n", $2->st_name);
							}else{
								printf("%s is already declared.\n", el->st_name);
							}
						}
			   	| INT ID ASSIGN ICONST SEMI
			   			{
							list_t* el = search($2 -> st_name);
							if(el ==NULL){
								insert($2->st_name, strlen($2->st_name), INT_TYPE);
								gen_code(LD_INT_VALUE, $4);
								$2->address = address-1;
								gen_code(STORE, address-1);
							}else{
								printf("%s is already declared.\n", el->st_name);
							}
						} 
				| INT ID ASSIGN FCONST SEMI
			   			{
							printf("ERROR!! Type missmatch.");
						}
			  ;



%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	flag = yyparse();
	
	printf("Parsing finished!\n");	

	printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");
	print_code();

	printf("\n\n================MIPS assembly================\n");
	print_assembly();

	return flag;
}
