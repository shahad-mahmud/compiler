%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	int flag = 0;

%}

str "Ami koto percent Flex​ ​pari?"

%%

{str} {flag=1;}
"\n"  {
    if(flag==1)
        printf("100%% pari\n");
    else
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
