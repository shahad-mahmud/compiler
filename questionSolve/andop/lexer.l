/* This is for making a calculator */
%option noyywrap

%{
    /* C stuffs */
    #include "parser.tab.h" /* holds token definations */
%}

/* regular expressions */
delim           [ \t]
white_space     ({delim})+
digit           [0-1][0-1]
number          ({digit})+

/* token detections */
%%
{white_space}   {}
{digit}        {yylval = atoi(yytext); return NUM;}
"&"             {return AND;}
\n              {return EOL;}
.               {printf("Invalid Character\n");}
%%