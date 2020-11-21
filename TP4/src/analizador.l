%option noyywrap

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "analizador.tab.h"

%}

ESPECIFICADOR_CLASE_ALMACENAMIENTO "typedef"|"static"|"auto"|"extern"|"register"
ESPECIFICADOR_DE_TIPO "void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned"
CALIFICADOR_DE_TIPO "const"|"volatile"
STRUCT_O_UNION "struct"|"union"
ENUM "enum"
IF "if"
ELSE "else"
SWITCH "switch"
WHILE "while"
DO "do"
FOR "for"
CASE "case"
DEFAULT "default"
CONTINUE "continue"
BREAK "break"
RETURN "return"

OPERADORES "*"|"/"|"-"|"+"|"&"|"%"|"<"|">"|"!"
OPERADOR_ASIGNACION "="|"*="|"/="|"%="|"+="|"-="|"^="
OPERADOR_O_LOGICO "||"
OPERADOR_Y_LOGICO "&&"
COMPARADOR_IGUALDAD "=="
COMPARADOR_DISTINTO "!="
MAYOR_O_IGUAL ">="
MENOR_O_IGUAL "<="
OPERADOR_INCREMENTO "++"
OPERADOR_DECREMENTO "--"
SIZE_OF "sizeof"
FLECHA "->"

IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*
CARACTERES_DE_PUNTUACION [(){}\[\]\;\,]
LITERAL_CADENA \"[^"]*\"

DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXA [0-9a-fA-F]

%%

{ESPECIFICADOR_CLASE_ALMACENAMIENTO} {yylval.cadena = strdup(yytext); return ESPECIFICADOR_CLASE_ALMACENAMIENTO;}

{ESPECIFICADOR_DE_TIPO} {yylval.cadena = strdup(yytext); return ESPECIFICADOR_DE_TIPO;}

{CALIFICADOR_DE_TIPO} {yylval.cadena = strdup(yytext); return CALIFICADOR_DE_TIPO;}

{STRUCT_O_UNION} {yylval.cadena = strdup(yytext); return STRUCT_O_UNION;}

{ENUM} {yylval.cadena = strdup(yytext); return ENUM;}

{IF} {yylval.cadena = strdup(yytext); return IF;}

{ELSE} {yylval.cadena = strdup(yytext); return ELSE;}

{SWITCH} {yylval.cadena = strdup(yytext); return SWITCH;}

{WHILE} {yylval.cadena = strdup(yytext); return WHILE;}

{DO} {yylval.cadena = strdup(yytext); return DO;}

{FOR} {yylval.cadena = strdup(yytext); return FOR;}

{CASE} {yylval.cadena = strdup(yytext); return CASE;}

{DEFAULT} {yylval.cadena = strdup(yytext); return DEFAULT;}

{CONTINUE} {yylval.cadena = strdup(yytext); return CONTINUE;}

{BREAK} {yylval.cadena = strdup(yytext); return BREAK;}

{RETURN} {yylval.cadena = strdup(yytext); return RETURN;}

{OPERADORES} {return yytext[0];}

{OPERADOR_ASIGNACION} {yylval.cadena = strdup(yytext); return OPERADOR_ASIGNACION;}

{OPERADOR_O_LOGICO} {yylval.cadena = strdup(yytext); return OPERADOR_O_LOGICO;}

{OPERADOR_Y_LOGICO} {yylval.cadena = strdup(yytext); return OPERADOR_Y_LOGICO;}

{COMPARADOR_IGUALDAD} {yylval.cadena = strdup(yytext); return COMPARADOR_IGUALDAD;}

{COMPARADOR_DISTINTO} {yylval.cadena = strdup(yytext); return COMPARADOR_DISTINTO;}

{MAYOR_O_IGUAL} {yylval.cadena = strdup(yytext); return MAYOR_O_IGUAL;}

{MENOR_O_IGUAL} {yylval.cadena = strdup(yytext); return MENOR_O_IGUAL;}

{OPERADOR_INCREMENTO} {yylval.cadena = strdup(yytext); return OPERADOR_INCREMENTO;}

{OPERADOR_DECREMENTO} {yylval.cadena = strdup(yytext); return OPERADOR_DECREMENTO;}

{SIZE_OF} {yylval.cadena = strdup(yytext); return SIZE_OF;}

{FLECHA} {yylval.cadena = strdup(yytext); return FLECHA;}

{IDENTIFICADOR} {yylval.cadena = strdup(yytext); return IDENTIFICADOR;}

{CARACTERES_DE_PUNTUACION} {return yytext[0];}

{LITERAL_CADENA} {yylval.cadena = strdup(yytext);; return LITERAL_CADENA;}

[1-9]{DIGITO_DECIMAL}* {yylval.entero = atoi(yytext); return CONSTANTE_ENTERA;}

0{DIGITO_OCTAL}* {yylval.entero = strtol(yytext, NULL, 0); return CONSTANTE_ENTERA;}

0[xX]{DIGITO_HEXA}+ {yylval.entero = strtol(yytext, NULL, 0); return CONSTANTE_ENTERA;}

[0–9]*\.[0–9]+ {yylval.flotante = atof(yytext); return CONSTANTE_REAL;}

[0-9]*(\.)[0-9]+([eE]([\+\-]?)[0-9]+)? {yylval.flotante = atof(yytext); return CONSTANTE_REAL;}

\'.\' {yylval.cadena = strdup(yytext); return CONSTANTE_CARACTER;}

[.]* {yylval.cadena = strdup(yytext); return ERROR;}

%%

// \/\/[^\n]* { } 

// \/\*[^(\*\/)]*\*+\/ { } 