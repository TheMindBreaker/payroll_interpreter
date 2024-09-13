%{
#include "y.tab.h"
%}

%%

"EMPLOYEE"             { return EMPLOYEE; }
"ID"                   { return ID; }
"SALARY"               { return SALARY; }
"LIST"                 { return LIST; }
"PAYROLL_ALL"          { return PAYROLL_ALL; }
"PAYROLL_EMPLOYEE"     { return PAYROLL_EMPLOYEE; }
"SAVE"                 { return SAVE; }
"LOAD"                 { return LOAD; }
\"[^\"]+\"             { yylval.sval = strdup(yytext + 1); yytext[strlen(yytext) - 1] = 0; return IDENTIFIER; } // Read strings between quotes
[A-Za-z][A-Za-z0-9_-]* { yylval.sval = strdup(yytext); return IDENTIFIER; }  // Allow alphanumeric and underscores/dashes in identifiers
[0-9]+                 { yylval.ival = atoi(yytext); return NUMBER; }
[\n\t ]+               ;  // Ignore spaces and newlines
.                      { return yytext[0]; }  // Any other character

%%

int yywrap() {
    return 1;
}
