%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

NUM         [0-9]+
IDENT       [a-zA-Z_][a-zA-Z0-9_]*

%%

{NUM} {
    yylval.attributes.value = atoi(yytext); // Convert string to integer
    yylval.attributes.temp = 0;            // Initialize temporary value to zero
    return NUMBER;
}

{IDENT} {
    yylval.id = strdup(yytext); // Duplicate the string for identifier
    return IDENTIFIER;
}

"+"       { return PLUS; }

"-"       { return MINUS; }

"*"       { return MULTIPLY; }

"/"       { return DIVIDE; }

"="       { return ASSIGN; }

"("       { return LPAREN; }

")"       { return RPAREN; }

";"       { return SEMICOLON; }

[ \t\n]+  { /* Skip whitespace */ }

. {
    fprintf(stderr, "Invalid character: %s\n", yytext);
}

%%

int yywrap() {
    return 1; // Indicate end of input
}
