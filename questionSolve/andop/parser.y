%{
    /* the C stuffs */
    #include <stdio.h>
    void yyerror(char* s);
    int yylex();
%}

%token NUM AND EOL //declear all the tokens
%start operation // tell where to start

/* The grammers */
%%
    operation: operation andop EOL {printf("\n\n>");}
            | operation EOL {printf(">");}
            | /* blank */
            ;
    andop: NUM AND NUM{
        
        int n1 = $1;
        int n2 = $3;

        int res = (n1%10) && (n2%10);
        int res1= ((n1/10) && (n2/10));

        printf(">%d%d",res1, res);
    
    }
            | NUM;
%%

/* The C functions */
int main()
{
    printf(">");
    yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}