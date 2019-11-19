	no3:parser.y lexer.l
			bison -d parser.y  
			flex lexer.l  
			gcc -o a.out parser.tab.c lex.yy.c  
			./a.out

	clear: 
			rm *.txt, *.tab.h 