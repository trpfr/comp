%{
    #include "y.tab.h"
    int yywrap();
    int countn=0;
%}

%option yylineno
alpha   [a-zA-Z]
digit   [0-9]

%%

"/*"([^*]|\*+[^*/])*\*+"/"         { ; } 

"bool" { strcpy(yylval.nd_obj.name,(yytext)); return BOOL; }
"char" { strcpy(yylval.nd_obj.name,(yytext)); return CHAR; }
"int" { strcpy(yylval.nd_obj.name,(yytext)); return INT; }
"real" { strcpy(yylval.nd_obj.name,(yytext)); return REAL; }
"string" { strcpy(yylval.nd_obj.name,(yytext));return STR; }
"int*" { strcpy(yylval.nd_obj.name,(yytext)); return INT_P; }
"char*" { strcpy(yylval.nd_obj.name,(yytext)); return CHAR_P; }
"real*" { strcpy(yylval.nd_obj.name,(yytext)); return REAL_P; }
"if" { strcpy(yylval.nd_obj.name,(yytext)); return IF; }
"else" { strcpy(yylval.nd_obj.name,(yytext)); return ELSE; }
"while" { strcpy(yylval.nd_obj.name,(yytext)); return WHILE; }
"for" { strcpy(yylval.nd_obj.name,(yytext)); return FOR; }
"var" { strcpy(yylval.nd_obj.name,(yytext)); return VAR; }     
"arg->" { strcpy(yylval.nd_obj.name,(yytext)); return ARGS; } 
"function" { strcpy(yylval.nd_obj.name,(yytext)); return FUNCTION; }
"return" { strcpy(yylval.nd_obj.name,(yytext)); return RETURN; }
"null" { strcpy(yylval.nd_obj.name,(yytext)); return NULL_VAL; }
"void" { strcpy(yylval.nd_obj.name,(yytext)); return VOID; }
"do" { strcpy(yylval.nd_obj.name,(yytext)); return DO; }

"&&" { strcpy(yylval.nd_obj.name,(yytext)); return AND; }
"/"  { strcpy(yylval.nd_obj.name,(yytext)); return DIVIDE; }
"="  { strcpy(yylval.nd_obj.name,(yytext)); return ASSIGN; }
"==" { strcpy(yylval.nd_obj.name,(yytext)); return EQ; }
">"  { strcpy(yylval.nd_obj.name,(yytext)); return GT; }
">=" { strcpy(yylval.nd_obj.name,(yytext)); return GE; }
"<"  { strcpy(yylval.nd_obj.name,(yytext)); return LT; }
"<=" { strcpy(yylval.nd_obj.name,(yytext)); return LE; }
"!"  { strcpy(yylval.nd_obj.name,(yytext)); return NOT; }
"!=" { strcpy(yylval.nd_obj.name,(yytext)); return NE; }
"||" { strcpy(yylval.nd_obj.name,(yytext)); return OR; }
"+"   { strcpy(yylval.nd_obj.name,(yytext)); return ADD; }
"&"  { strcpy(yylval.nd_obj.name,(yytext)); return ADDR; } 
"*"  { strcpy(yylval.nd_obj.name,(yytext)); return MULTIPLY; }
"-"  { strcpy(yylval.nd_obj.name,(yytext)); return SUBTRACT; }

"true"                      { strcpy(yylval.nd_obj.name,(yytext)); return TRUE; }
"false"                     { strcpy(yylval.nd_obj.name,(yytext)); return FALSE; }
['].[']                     { strcpy(yylval.nd_obj.name,(yytext)); return CHARACTER; }
{digit}+                { strcpy(yylval.nd_obj.name,(yytext)); return INTEGER; }
{digit}+\.{digit}{1,6}  { strcpy(yylval.nd_obj.name,(yytext)); return REAL_NUM; }
["].*["]                    { strcpy(yylval.nd_obj.name,(yytext)); return STRING; }

(_|{alpha})(_|{alpha}|{digit})*   { strcpy(yylval.nd_obj.name,(yytext)); return ID; }

"{"                         { strcpy(yylval.nd_obj.name,(yytext)); return LEFT_BRACE; }
"}"                         { strcpy(yylval.nd_obj.name,(yytext)); return RIGHT_BRACE; }

[ \t]+                      { ; }
[\n]                        { countn++; }
. { return yytext[0]; }

%%

int yywrap() {
    return 1;
}

