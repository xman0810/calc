#include "lex.h"

void gen_token(ParseContext *psParseContext) {
  FILE * pInputFile = NULL;
  pInputFile = fopen("vs.txt", "r"); 
  
  if (!pInputFile) {
    assert(0 && "Failed to open file\n");
  }
  fseek(pInputFile, 0, SEEK_END);
  unsigned int  uFileSize = ftell(pInputFile);
  char* pszSourceCode = NULL;
  pszSourceCode = (char*)malloc(sizeof(char) * (uFileSize + 1));
  if (! pszSourceCode) {
    assert(0 && "Failed to create buffer for file\n");
  }
  
  fseek(pInputFile, 0, SEEK_SET);
  uFileSize  = fread(pszSourceCode, sizeof(char), uFileSize, pInputFile);

  pszSourceCode[uFileSize] = '\0';
  fclose(pInputFile);

  printf("%s\n", pszSourceCode);

  unsigned int i = 0;
  char curChar = pszSourceCode[i];
  unsigned int numTokens = 0;
  Token* curToken = psParseContext->psTokenList;
  while (curChar) {
    if (curChar == '\n')
      break;
    if (curChar >= '0' && curChar <= '9') {
      const char* startPtr = pszSourceCode + i;
      const char* endPtr = startPtr;
      while (isdigit(*endPtr)) {
        ++endPtr;
        i++;
      }
      unsigned int len = endPtr - startPtr;
      char* curConst = (char*)malloc(sizeof(char) * (len + 1));
      memcpy(curConst, startPtr, len);
      curConst[len] = '\0';
      curToken->eTokenName = TOK_INTCONSTANT; 
      curToken->value = atoi(curConst); 
      free(curConst); 
    } else {
      switch (curChar) {
        case '+':
          curToken->eTokenName = TOK_PLUS;
          break;
        case '-':
          curToken->eTokenName = TOK_MINUS;
          break;
        case '*':
          curToken->eTokenName = TOK_MUL;
          break;
        case '/':
          curToken->eTokenName = TOK_DIV;
          break;
        case ';':
          curToken->eTokenName = TOK_SEMICOLON;
          break;
        default:
          assert(0 && "not supported symbol");
      }
      i++;
    }
    curToken++;
    numTokens++;
    curChar = pszSourceCode[i];
  }
  psParseContext->uNumTokens = numTokens;
}
