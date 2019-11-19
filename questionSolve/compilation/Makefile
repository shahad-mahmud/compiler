prog: 
	gcc -E prog.c > prog.i
	gcc -S prog.c
	gcc -C prog.c -o prog.obj
	gcc prog.c
	objdump -t prog.obj > observe.i

clear:
	rm *.out *.i *.o *.obj *.s