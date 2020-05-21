Gram=y.tab.c y.tab.h

run: all
	./matrix_calculator

all: $(Gram) matriz_cal.c double_array.o
	gcc -o matrix_calculator y.tab.c matriz_cal.c double_array.o
	@echo Compiled

double_array.o: double_array.c
	gcc -c double_array.c

matriz_cal.c:
	@echo "Si esta"

$(Gram): matriz_cal.y
	yacc -d matriz_cal.y -v

lex.yy.c: matriz_cal.l
	flex matriz_cal.l

clean:
	@rm -f *.out *.tab.* matrix_calculator double_array.o
	@echo Clean
