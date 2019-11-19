%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.c"
    #include "codegen.h"
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
program:{gen_code(START,-1);} code {gen_code(HALT,-1);};

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
                    gen_code(STORE,id->address);
                    }
                
            }
            | INT ID{
                list_t* id =search($2->st_name);
                
                gen_code(LD_VAR,id->address);
                
            }COMMA ID{
                list_t* id =search($5->st_name);
                
                gen_code(LD_VAR,id->address);
                
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
                gen_code(LD_INT_VALUE,$4);
                list_t* id = search($2->st_name);
                gen_code(STORE,id->address);
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
            ;



statement: assignment SEMI
            |ID INCR
            | PRINT ID SEMI
            {
                list_t* id = search($2->st_name);
                gen_code(WRITE_INT,id->address);
            }
            | exp SEMI
            ;



assignment:  ID ASSIGN exp 
            {
                
                list_t* id = search($1->st_name);
                if(id == NULL )
                {
                    printf("Dont defined before\n");
                    exit(1);
                }
                else{
                    int id_type = id->st_type;

                    if(id_type != $3)
                    {
                        printf("Data type not matched at line %d\n",lineno);
                    }
                    else{
                        gen_code(STORE,id->address);
                    }
                }
                
            }  
            
            ;

if_statement: IF LPAREN exp RPAREN {gen_code(JMP_FALSE,1);} LBRACE statements RBRACE {gen_code(GOTO,2);} ELSE {gen_code(LABEL,label_no);label_no++;} LBRACE statements RBRACE {gen_code(LABEL,label_no);label_no++;}  ;
while_statements: WHILE {gen_code(LABEL,1);} LPAREN exp RPAREN {gen_code(JMP_FALSE,2);} LBRACE statements{gen_code(GOTO,1);} RBRACE{gen_code(LABEL,2);}  ;
for_statement: FOR LPAREN statement {gen_code(LABEL,5);}exp { gen_code(JMP_FALSE,6); } SEMI exp RPAREN LBRACE statements {gen_code(GOTO,5);} RBRACE {gen_code(LABEL,6);};
do_statement:DO {gen_code(LABEL,7);} LBRACE statements RBRACE WHILE LPAREN exp {gen_code(JMP_FALSE,8);} RPAREN {gen_code(GOTO,7);} SEMI{gen_code(LABEL,8);} ;
exp: ID 
        {
            list_t* id =search($1->st_name);
            if(id==NULL)
            {
                $$ = UNDEF;
            }
            else{
                $$ = id->st_type;
                gen_code(LD_VAR,id->address);
            }
        }
    |ID INCR {
        list_t* l = search($1->st_name);

		

		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}
        else{
            gen_code(LD_VAR,l->address);
            gen_code(LD_INT,1);
            gen_code(ADD,-1);
            gen_code(STORE,l->address);
        }
    }  
    | constant {$$=$1;}
    | exp ADDOP exp
         {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
             }
            else{
                gen_code(ADD,-1);
            }
        }
    | exp SUBOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            else{
                gen_code(SUB,-1);
            }
        }
    | exp DIVOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            else{
                gen_code(DIV,-1);
            }
        }
    | exp MULOP exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            else{
                gen_code(MUL,-1);
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
            else{
                gen_code(LTN,-1);
            }
        }
    | exp LTE exp
        {
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            else{
                printf("Less and equal done\n");
                // gen_code(LTN,-1);
            }
        }
    | exp GTE exp    
        {      
            if($1 != $3)
            {
                printf("Operand Type didn't match at line %d\n",lineno);
                exit(1);
            }
            else{
                printf("Greater and equal done\n");
                // gen_code(LTN,-1);
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
constant:ICONST {$$=INT_TYPE;gen_code(LD_INT,$1);}  
    | FCONST {$$=REAL_TYPE;} 
    
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
 
 printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");

  print_code();
 printf("\n\n================MIPS assembly================\n");
    print_assembly();

}