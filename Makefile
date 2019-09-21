compiler:  	parser.y lexer.l
			bison -d parser.y  
			flex lexer.l  
			gcc -o a.out parser.tab.c lex.yy.c  
			rm lex.yy.c parser.tab.c
			./a.out <input.c> output.txt