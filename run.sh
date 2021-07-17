bison -d calc.y
gcc -g -o  calc  calc.tab.h lex.h calc.tab.c lex.c
