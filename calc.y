%{
#include <stdio.h>
#include "lex.h"

typedef struct _YYSTYPETAG {
  Token* psToken;
} _YYSTYPE;

#define YYSTYPE _YYSTYPE


unsigned int calc_lex(YYSTYPE *lvalp, ParseContext *psParseContext) {
  unsigned int uTokenIndex;
  lvalp->psToken = &psParseContext->psTokenList[psParseContext->uCurrentToken++]; 
  return lvalp->psToken->eTokenName;
}

void calc_error(ParseContext *psParseContext, const char * msg) {}
%}

%name-prefix "calc_"
%parse-param {struct ParseContextTAG *psParseContext}
%lex-param {struct ParseContextTAG *psParseContext}
%define api.pure

%token TOK_INTCONSTANT
%token TOK_PLUS
%token TOK_MINUS
%token TOK_MUL
%token TOK_DIV
%token TOK_SEMICOLON

%left TOK_PLUS TOK_MINUS
%left TOK_MUL TOK_DIV

%%

S  : S E TOK_SEMICOLON {
       printf("The res is %d\n", psParseContext->stack[0]);
     }
   |          {}
   ;

E  : E TOK_PLUS E   {
       unsigned int lhs = psParseContext->stack[psParseContext->pos - 2];
       unsigned int rhs = psParseContext->stack[psParseContext->pos - 1];
       unsigned int res = lhs + rhs;
       psParseContext->stack[psParseContext->pos - 2] = res;
       psParseContext->pos = psParseContext->pos - 1;
     }
   | E TOK_MINUS E   {
       unsigned int lhs = psParseContext->stack[psParseContext->pos - 2];
       unsigned int rhs = psParseContext->stack[psParseContext->pos - 1];
       unsigned int res = lhs - rhs;
       psParseContext->stack[psParseContext->pos - 2] = res;
       psParseContext->pos = psParseContext->pos - 1;
     }
   | E TOK_MUL E   {
       unsigned int lhs = psParseContext->stack[psParseContext->pos - 2];
       unsigned int rhs = psParseContext->stack[psParseContext->pos - 1];
       unsigned int res = lhs * rhs;
       psParseContext->stack[psParseContext->pos - 2] = res;
       psParseContext->pos = psParseContext->pos - 1;
     }
   | E TOK_DIV E   {
       unsigned int lhs = psParseContext->stack[psParseContext->pos - 2];
       unsigned int rhs = psParseContext->stack[psParseContext->pos - 1];
       unsigned int res = lhs / rhs;
       psParseContext->stack[psParseContext->pos - 2] = res;
       psParseContext->pos = psParseContext->pos - 1;
     }
   | TOK_INTCONSTANT { 
       psParseContext->stack[psParseContext->pos] = $1.psToken->value; 
       psParseContext->pos++;
     }
   ;

%%

int main() {
 
  ParseContext psParseContext;
  psParseContext.psTokenList = (Token *)malloc(sizeof(Token) * MAX_TOKEN); 
  psParseContext.uCurrentToken = 0;
  psParseContext.uNumTokens = 0;
  psParseContext.pos = 0;
  memset(psParseContext.stack, 0, sizeof(int) * MAX_TOKEN);
  
  gen_token(&psParseContext);
  calc_parse(&psParseContext);
  free(psParseContext.psTokenList);
}

