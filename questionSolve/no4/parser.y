%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.c"

	#include "semantic.h"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
    int label_no =1;
    int while_no;
%}

%union{
    int int_val;
    float float_val;
    char char_val;
    list_t* id;
	
	
}

%token <int_val> INT FLOAT CHAR IF ELSE WHILE CONTINUE BREAK PRINT COMMA FOR DO
%token<int_val> ADDOP SUBOP MULOP DIVOP INCR EQUOP LT GT LTE GTE NTEQUOP
%token<int_val> LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token <id> ID
%token <int_val> ICONST
%token <float_val>  FCONST
%token <char_val> CCONST


%type <int_val>constant  exp  

%left ADDOP SUBOP
%left MULOP DIVOP
%left LT GT
%left EQUOP NTEQUOP
%right ASSIGN INCR

%start program

%%
program: code ;

code: statements;
statements: statements statement | statements declaration | statements if_statement | statements while_statements | statements for_statement | statements do_statement |  ;

declaration: INT ID SEMI
            {
                
                if (id_check($2->st_name)!=-1)
                    {
                        printf("Variable is redeclared before . Error at line on %d\n",lineno);
                        exit(1);
                    }
                    else
                    {
                    insert($2->st_name,strlen($2->st_name),INT_TYPE);
                    list_t* id = search($2->st_name);
                    
                    }
                
            }
            | INT ID{
                list_t* id =search($2->st_name);
                
                
                
            }COMMA ID{
                list_t* id =search($5->st_name);
                
               
                
            }SEMI
            
            | INT ID ASSIGN ICONST SEMI
            {
                if (id_check($2->st_name)!=-1)
                {
                    printf("Variable is redeclared before . Error at line on %d\n",lineno);
                    exit(1);
                }
                else
                {
                insert($2->st_name,strlen($2->st_name),INT_TYPE);
               
                list_t* id = search($2->st_name);
               
                }
            }
            | INT ID ASSIGN FCONST SEMI 
            {
                printf("Type Error - Int and Float conflict at line %d\n",lineno);
                // exit(1);
            }
            | INT ID ASSIGN CCONST SEMI 
            {
                printf("Type Error - Int and Char conflictat line %d\n",lineno);
                // exit(1);
            }
            | FLOAT ID ASSIGN CCONST SEMI 
            {
                printf("Type Error - Float and Char conflict at line %d\n",lineno);
                // exit(1);
            }
            | FLOAT ID ASSIGN ICONST SEMI 
            {
                printf("Type Error - FLoat and Int conflict at line %d\n",lineno);
                // exit(1);
            }
            | FLOAT ID SEMI
            {
                if (id_check($2->st_name)!=-1)
                {
                    printf("Variable is redeclared before . Error at line on %d\n",lineno);
                    exit(1);
                }
                else
                {
                 insert($2->st_name,strlen($2->st_name),REAL_TYPE);
                }
            }
            | FLOAT ID ASSIGN FCONST SEMI
            {
                if (id_check($2->st_name)!=-1)
                {
                    printf("Variable is redeclared before . Error at line on %d\n",lineno);
                    exit(1);
                }
                else
                {
                insert($2->st_name,strlen($2->st_name),REAL_TYPE);
                }
            }
            | CHAR ID ASSIGN CCONST SEMI
            {
                if (id_check($2->st_name)!=-1)
                {
                    printf("Variable is redeclared before . Error at line on %d\n",lineno);
                    exit(1);
                }
                else
                {
                insert($2->st_name,strlen($2->st_name),REAL_TYPE);
                }
            }
            | CHAR ID ASSIGN ICONST SEMI
            {
                 printf("Type Error - Int and Char conflict at line %d\n",lineno);
            }
            | CHAR ID ASSIGN FCONST SEMI
            {
                 printf("Type Error - Int and Float conflict at line %d\n",lineno);
            }
            ;



statement: assignment SEMI
            |ID INCR
            | PRINT ID SEMI
            {
                list_t* id = search($2->st_name);
                
                
            }
            | exp SEMI
            ;



assignment:  ID ASSIGN exp 
            {
                
                list_t* id = search($1->st_name);
                if(id == NULL )
                {
                    printf("Dont defined before\n");
                    // exit(1);
                }
                else{
                    int id_type = id->st_type;

                    if(id_type != $3)
                    {
                        printf("Data type not matched at line %d\n",lineno);
                    }
                    else{
                       
                    }
                }
                
            }  
            
            ;

if_statement: IF LPAREN exp RPAREN LBRACE statements RBRACE  ELSE  LBRACE statements RBRACE ;
while_statements: WHILE  LPAREN exp RPAREN LBRACE statements RBRACE ;
for_statement: FOR LPAREN statement exp  SEMI exp RPAREN LBRACE statements  RBRACE ;
do_statement:DO  LBRACE statements RBRACE WHILE LPAREN exp RPAREN  SEMI ;
exp: ID 
        {
            list_t* id =search($1->st_name);
            if(id==NULL)
            {
                $$ = UNDEF;
            }
            else{
                $$ = id->st_type;
               
            }
        }
    |ID INCR {
        list_t* l = search($1->st_name);

		

		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}
    }  
    | constant {$$=$1;}
    | exp ADDOP exp
         {
            if($1 != $3)
            {
                printf("Operand Type (INT & DOUBLE) didn't match at line %d\n",lineno);
                // exit(1);
             }
            
        }
    | exp SUBOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type (INT & DOUBLE) didn't match at line %d\n",lineno);
                // exit(1);
            }
            
        }
    | exp DIVOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            
        }
    | exp MULOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            
        }
    | exp GT exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
        }
    | exp LT exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
           
        }
    | exp LTE exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            
        }
    | exp GTE exp    
        {      
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            
        }
    | exp EQUOP exp 
    {
        printf("Equal operator works !!!!\n");
    }
    | exp NTEQUOP exp 
    {
        printf("Not Equal operator works !!!!\n");
    }

    | LPAREN exp RPAREN
    ;
constant:ICONST {$$=INT_TYPE;}  
    | FCONST {$$=REAL_TYPE;}
    | CCONST {$$=CHAR_TYPE;} 
    
    ;



%%

void yyerror()
{
    fprintf(stderr,"Syntax error at line %d\n",lineno);
    exit(1);
}

int main(int argc, char *argv[])
{
    int flag;
    flag = yyparse();
    printf("Parsing Finished\n");


}