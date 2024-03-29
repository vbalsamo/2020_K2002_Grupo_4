
%option noyywrap

%{

#include <stdio.h>
#include <math.h>
#include "listas.h"
#include "operadores.h"
#include "masfunciones.h"

int sumaDecimales = 0;
int linea = 1;
double constanteReal;
Nodo *listaDecimales = NULL;
Nodo *listaOctales = NULL;
Nodo *listaHexadecimales = NULL;
NodoChar *listaDeComentarios = NULL;
NodoChar *listaDeComentariosLargos = NULL;
NodoL *listaDeLiteralesCadena = NULL;
NodoId *listaDeIdentificadores = NULL;
NodoChar *listaDeConstantesCaracter = NULL;
NodoChar *listaDeTiposDeDato = NULL;
NodoChar *listaDeEstructurasDeControl = NULL;
NodoChar *listaDeOtrasPalabrasReservadas = NULL;
NodoL *listaDeCaracteresDesconocidos = NULL;
NodoReal *listaDeConstantesReales = NULL;


%}

ESTRUCTURAS_DE_CONTROL "if"|"else"|"do"|"for"|"while"|"switch"|"case"|"break"|"continue"|"default"|"return"
TIPOS_DE_DATO "char"|"double"|"float"|"int"|"long"|"short"|"struct"|"void"|"unsigned"|"signed"|"const"|"typedef"|"enum"|"union"
OTRAS_PALABRASRESERVADAS "sizeof"|"auto"|"extern"|"register"|"goto"|"static"|"volatile"

OPERADORES "*"|"/"|"-"|"+"|"++"|"&"|"%"|"<"|">"|"="|"!"|"!="|"&&"|"<="|">="|"+="|"=="|"||"
CARACTERES_DE_PUNTUACION [(){}\[\]\;\,]

DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXA [0-9a-fA-F]

%%

[\n] {linea++;}

[1-9]{DIGITO_DECIMAL}* {
    int numero = atoi(yytext);
    sumaDecimales += numero;
    insertar(&listaDecimales, numero);
}

0{DIGITO_OCTAL}* {
    int numero = strtol(yytext, NULL, 8);
    insertar(&listaOctales, numero);
}

0[xX]{DIGITO_HEXA}+ {
    int numero = strtol(yytext, NULL, 16);
    insertar(&listaHexadecimales, numero);
}

[0–9]*\.[0–9]+ {
    constanteReal = atof(yytext); insertarReal(&listaDeConstantesReales, constanteReal);
}

[0-9]*(\.)[0-9]+([eE]([\+\-]?)[0-9]+)? {
    constanteReal = atof(yytext); insertarReal(&listaDeConstantesReales, constanteReal);
}

\/\/[^\n]* {
    insertarC(&listaDeComentarios, yytext);    
}

\/\*[^(\*\/)]*\*+\/ {
    insertarC(&listaDeComentariosLargos, yytext);    
}

\'(.|\\n)\' {
    insertarEnOrdenC(&listaDeConstantesCaracter, yytext);
}

{CARACTERES_DE_PUNTUACION} {
    agregarCaracter(yytext[0], caracteresP);
}

{OTRAS_PALABRASRESERVADAS} {
    insertarEnOrdenC(&listaDeOtrasPalabrasReservadas, yytext);
}

{TIPOS_DE_DATO} {
    insertarEnOrdenC(&listaDeTiposDeDato, yytext);
}

{ESTRUCTURAS_DE_CONTROL} {
    insertarEnOrdenC(&listaDeEstructurasDeControl, yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    insertarId(&listaDeIdentificadores, yytext);
}

\"[^"]*\" {
    insertarL(&listaDeLiteralesCadena, yytext, yyleng);
}

{OPERADORES} {
    agregarOperador(yytext, operadores);
}

[.]* {insertarL(&listaDeCaracteresDesconocidos, yytext, linea);}

%%

int main() {

    yyin = fopen("entrada.c", "r"); 
    yyout = fopen("salida.txt", "w");	
    yylex();
	
    FILE * archivoSalida = fopen("Informe.txt","w");
    
    mostrarTitulo(archivoSalida, "IDENTIFICADORES");
        mostrarListaId(archivoSalida, listaDeIdentificadores);

    mostrarTitulo(archivoSalida, "LITERALES CADENA");
        mostrarListaL(archivoSalida, listaDeLiteralesCadena);
    
    mostrarTitulo(archivoSalida, "PALABRAS RESERVADAS");
        mostrarSubtitulo(archivoSalida, "Tipos de dato");
        mostrarListaC(archivoSalida, listaDeTiposDeDato);
        mostrarSubtitulo(archivoSalida, "Estructuras de control");
        mostrarListaC(archivoSalida, listaDeEstructurasDeControl);
        mostrarSubtitulo(archivoSalida, "Otros");
        mostrarListaC(archivoSalida, listaDeOtrasPalabrasReservadas);
    
    mostrarTitulo(archivoSalida, "CONSTANTES");
        mostrarSubtitulo(archivoSalida, "Constantes Decimales");
        fprintf(archivoSalida, "        Lista de todos los decimales que aparecieron\n");
        mostrarLista(archivoSalida, listaDecimales);
        fprintf(archivoSalida, "\n        La suma de todos los decimales es %i \n", sumaDecimales);
        mostrarSubtitulo(archivoSalida, "Constantes Octales");
        mostrarListaOctal(archivoSalida, listaOctales);
        mostrarSubtitulo(archivoSalida, "Constantes Hexadecimales");
        mostrarListaHexa(archivoSalida, listaHexadecimales);
        mostrarSubtitulo(archivoSalida, "Constantes Reales");
        mostrarListaReales(archivoSalida, listaDeConstantesReales);
        mostrarSubtitulo(archivoSalida, "Constantes Caracter");
        mostrarListaEnumerada(archivoSalida, listaDeConstantesCaracter);
    
    mostrarTitulo(archivoSalida, "OPERADORES");
        mostrarOperadores(archivoSalida, operadores);
    
    mostrarTitulo(archivoSalida, "CARACTERES DE PUNTUACION");
        mostrarCdePuntuacion(archivoSalida, caracteresP);

    mostrarTitulo(archivoSalida, "COMENTARIOS");
        mostrarSubtitulo(archivoSalida, "Comentarios de una linea");
        mostrarListaC(archivoSalida, listaDeComentarios);
        mostrarSubtitulo(archivoSalida, "Comentarios largos");
        mostrarListaC(archivoSalida, listaDeComentariosLargos);

    mostrarTitulo(archivoSalida, "CARACTERES NO RECONOCIDOS");
    mostrarListaD(archivoSalida, listaDeCaracteresDesconocidos);
    

    return 0;
}

