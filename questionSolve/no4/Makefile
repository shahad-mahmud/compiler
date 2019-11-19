main:
	bison -d parser.y
	flex lexer.l
	gcc -o a.out parser.tab.c lex.yy.c
	./a.out <full_example.c> output.txt
main2:
	bison -d parser.y
	flex lexer.l
	gcc -o a.out parser.tab.c lex.yy.c
	./a.out

clean:
	rm *.out
	rm *.yy.c