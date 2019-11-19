aa: parser.y lexer.l
			bison -d parser.y
			flex lexer.l
			gcc -o a.out parser.tab.c lex.yy.c
			./a.out

clear: 
			rm *.out lex.yy.c *.tab.c *.tab.h