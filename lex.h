#ifndef _FLEX_
#define _FLEX_
struct ParseContextTAG;
struct GLSLTreeContextTAG;
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#define MAX_TOKEN 100

#define TokenName enum yytokentype
typedef struct TokenTAG {
	  TokenName eTokenName;  
	    unsigned int value;
} Token;


typedef struct ParseContextTAG{
	  Token    *psTokenList;
	    unsigned int uNumTokens;
	      unsigned int uCurrentToken;
	        unsigned int stack[MAX_TOKEN];
		  unsigned int pos;
} ParseContext;

void gen_token(ParseContext *psParseContext);
#endif
