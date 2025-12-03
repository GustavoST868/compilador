/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_ANALISADORSINTATICO_TAB_H_INCLUDED
# define YY_YY_ANALISADORSINTATICO_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    tipo_inteiro = 258,            /* tipo_inteiro  */
    tipo_inteiro_longo = 259,      /* tipo_inteiro_longo  */
    tipo_racional = 260,           /* tipo_racional  */
    tipo_racional_longo = 261,     /* tipo_racional_longo  */
    tipo_caractere = 262,          /* tipo_caractere  */
    tipo_boleano = 263,            /* tipo_boleano  */
    se = 264,                      /* se  */
    senao = 265,                   /* senao  */
    enquanto = 266,                /* enquanto  */
    para = 267,                    /* para  */
    nao = 268,                     /* nao  */
    e = 269,                       /* e  */
    ou = 270,                      /* ou  */
    verdadeiro = 271,              /* verdadeiro  */
    falso = 272,                   /* falso  */
    retorne = 273,                 /* retorne  */
    mostrar = 274,                 /* mostrar  */
    leia = 275,                    /* leia  */
    identificador = 276,           /* identificador  */
    numero_inteiro = 277,          /* numero_inteiro  */
    numero_racional = 278,         /* numero_racional  */
    texto = 279,                   /* texto  */
    caractere = 280,               /* caractere  */
    igual = 281,                   /* igual  */
    diferente = 282,               /* diferente  */
    menor_igual = 283,             /* menor_igual  */
    maior_igual = 284              /* maior_igual  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 53 "analisadorSintatico.y"

    int inteiro;
    long inteirolongo;
    float flt;
    double db;
    char *nome;
    class No *node;

#line 102 "analisadorSintatico.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_ANALISADORSINTATICO_TAB_H_INCLUDED  */
