%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	int flag = 0;

%}

ami "Ami"
flex "Flex"
pari "Pari"

%%
[ \t]+ {}
{ami} {printf("%s pari\n", yytext); flag = 1;}
{flex} {printf("%s pari\n", yytext); flag = 1;}
{pari} {printf("%s pari\n", yytext); flag = 1;}
"\n"  {
    if(flag==0)
        printf("No match found\n");        
} 
. {flag=0;}

%%

int main() 
{    
    // The function that starts the analysis 
    yylex(); 
  
    return 0; 
} 
