%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class No;

#include "analisadorSintatico.tab.h"

int contar_linha_sintatico_lexico = 1;

%}

%%

[ \t]+                 ;
\r                    ;
\n                    { contar_linha_sintatico_lexico++; }

"inteiro"             { return tipo_inteiro; }
"inteiroLongo"        { return tipo_inteiro_longo; }
"racional"            { return tipo_racional; }
"racionalLongo"       { return tipo_racional_longo; }
"letra"               { return tipo_caractere; }
"boleano"             { return tipo_boleano; }

"nao"                 { return nao; }
"se"                  { return se; }
"e"                   { return e; }
"ou"                  { return ou; }
"enquanto"            { return enquanto; }
"senao"               { return senao; }
"verdadeiro"          { return verdadeiro; }
"falso"               { return falso; }
"retorne"             { return retorne; }
"mostrar"             { return mostrar; }
"leia"                { return leia; }

\"([^\\"]|\\.)*\"     { 
                        yylval.nome = strdup(yytext);
                        return texto; 
                      }
\'([^\\']|\\.)*\'     { 
                        yylval.nome = strdup(yytext);
                        return caractere; 
                      }

[0-9]+\.[0-9]+        { 
                        yylval.flt = atof(yytext);
                        return numero_racional; 
                      }

[0-9]+                { 
                        yylval.inteiro = atoi(yytext);
                        return numero_inteiro; 
                      }

"=="                  { return igual; }
"!="                  { return diferente; }
"<="                  { return menor_igual; }
">="                  { return maior_igual; }
"<"                   { return '<'; }
">"                   { return '>'; }
"="                   { return '='; }

"+"                   { return '+'; }
"-"                   { return '-'; }
"*"                   { return '*'; }
"/"                   { return '/'; }
"%"                   { return '%'; }

"("                   { return '('; }
")"                   { return ')'; }
"["                   { return '['; }
"]"                   { return ']'; }
"{"                   { return '{'; }
"}"                   { return '}'; }
";"                   { return ';'; }
","                   { return ','; }
"."                   { return '.'; }
":"                   { return ':'; }

[a-zA-Z_][a-zA-Z0-9_]* { 
                         yylval.nome = strdup(yytext);
                         return identificador; 
                      }

.                     {
                          printf("erro lexico na linha %d: caractere (%s) nao reconhecido\n",
                                 contar_linha_sintatico_lexico, yytext);
                          exit(1);
                      }

%%

int yywrap() { return 1; }
