
%{

 #include "matriz_cal.h"
 #include "double_array.h"

  Matriz *mem[26];

  void yyerror (char *);
  int yylex (void);
%}

%union {
  Matriz *mat;
  int index;
}

  %token < mat > MATRIX
  %token < index > VARIABLE
  %type < mat > expr
  
  %right '=' 
  %left '+' '-' 
  %left '*' 
  %left INVERT 
  
%% 

list:	  %empty
	| list '\n' 
	| list expr '\n' 	{ imprimeMatriz ($2); }
	| list error '\n' 	{ yyerrok; }
	;	
expr:	  MATRIX 	{ $$ = $1; }
	| VARIABLE 	{
			if( mem[$1] == NULL ) {
				yyerror( "Variable no definida");
				$$ = NULL;
			} else {
				$$ = mem[$1];
			}
		}
	| VARIABLE '=' expr 	{ $$ = mem[$1] = $3; }
	| expr '+' expr 	{ $$ = sumaMatriz ($1, $3); }
	| expr '-' expr 	{ $$ = restaMatriz ($1, $3); }
	| expr '*' expr 	{ $$ = multiMatriz ($1, $3); }
	| '(' expr ')'	{ $$ = $2; }
	| '!' expr %prec INVERT 	{
			Matriz *mat_inv = creaMatriz (($2)->n);
			invierteMatriz ($2, mat_inv);
			$$ = mat_inv;
		}
	;	

%%


#include "double_array.h"
#include <ctype.h>
#include <stdio.h>

void
yyerror (char *s) {
  fprintf (stderr, "%s\n", s);
}

int
main (void) {
	yyparse ();
	return 0;
}

int
yylex () {
  int c;
  while ((c = getchar ()) == ' ' || c == '\t');
  if (c == EOF)
    return 0;
  if (c == '[') {
    int col = 0;
    int row = 1;
    double tdouble = 0.0;
    Array tarray;
    initArray (&tarray, 10);
    while ((c = getchar ()) != ']') {
      if (isdigit (c) || c == '-') {
        ungetc (c, stdin);
        scanf ("%lf", &tdouble);
        insertArray (&tarray, tdouble);
        col++;
      } else if (c == '|') {
        row++;
        col = 0;
      }
    }
    if(row < 2) return 0;
    Matriz *tmat = creaMatriz (row);
    int i,j,k;
    for (i = 0, k = 0; i < row; i++) {
      for (j = 0; j < row; j++, k++) {
        tmat->mat[i][j] = tarray.array[k];
      }
    }
    yylval.mat = tmat;
    return MATRIX;
  }
  if (islower (c)) {
    yylval.index = c - 'a';
    return VARIABLE;
  }
  //if (c == '\n')
    //lineno++;
  return c;
}
