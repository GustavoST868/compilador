%{
#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>
#include "nodes.h"

int contadorDeErros = 0;
int yyerror(const char *s);
int yylex(void);
extern int contar_linha_sintatico_lexico;
int obterLinhaDoErro(){
    return contar_linha_sintatico_lexico;
}	

//retirei um nome especifico para o programa
char* build_file_name = (char*)"";
%}

%define parse.error verbose

%token tipo_inteiro
%token tipo_inteiro_longo 
%token tipo_racional tipo_racional_longo tipo_caractere tipo_boleano
%token se senao enquanto para nao e ou
%token verdadeiro falso retorne mostrar leia
%token<nome> identificador
%token<inteiro> numero_inteiro 
%token<flt> numero_racional 
%token<nome> texto caractere
%token igual diferente menor_igual maior_igual

%left ou
%left e
%left igual diferente menor_igual maior_igual '<' '>'
%left '+' '-'
%left '*' '/'


%type<node> programa lista_comandos comando comando_correspondente comando_aberto
%type<node> comando_simples comando_composto
%type<node> comando_se_correspondente comando_se_aberto
%type<node> comando_para_correspondente comando_para_aberto
%type<node> comando_enquanto_correspondente comando_enquanto_aberto
%type<node> declaracao atribuicao tipo expressao valor
%type<node> regra_mostrar regra_leia chamada_de_funcao
%type<node> expressao_ou expressao_e expressao_comparacao expressao_aritmetica
%type<node> termo fator operador_unario operador_comparacao acesso_variavel
%type<node> para_inicializacao para_condicao para_incremento
%type<node> declaracao_sem_pv atribuicao_sem_pv
%type<node> mostrar_argumentos leia_destino argumentos_opcionais lista_argumentos

%union {
    int inteiro;
    long inteirolongo;
    float flt;
    double db;
    char *nome;
    class No *node;
}

%%

programa: lista_comandos   
        {
            if(contadorDeErros>0){
                printf("Programa com erros.\n");
            } else {
                Programa *prog = new Programa($1);
               
                VerificacaoSemanticaDeclaracao vd;
                vd.check(prog);
                vd.verificarTodasVariaveis();

                //dar um espaço da arvore para os erros semanticos
                //printf("\n");
                VerificacaoSemanticaTipos vt;
                vt.check(prog);
                
                printf("Programa reconhecido. \nÁrvore sintática:\n");
                prog->imprimirArvore();
                printf("\n");
                
                
                
                
            }
        }
        ;

lista_comandos: 
              { $$ = new ListaComandos(); }
              |
              lista_comandos comando
              { 
                if ($1 && $2) {
                    $1->append($2);
                    $$ = $1;
                } else {
                    $$ = new ListaComandos();
                }
              }
              ;

comando: comando_correspondente { $$ = $1; }
       | comando_aberto { $$ = $1; }
       ;

comando_correspondente: comando_simples { $$ = $1; }
                      | comando_composto { $$ = $1; }
                      | comando_se_correspondente { $$ = $1; }
                      | comando_para_correspondente { $$ = $1; }
                      | comando_enquanto_correspondente { $$ = $1; }
                      ;

comando_aberto: comando_se_aberto { $$ = $1; }
              | comando_para_aberto { $$ = $1; }
              | comando_enquanto_aberto { $$ = $1; }
              ;

comando_simples: declaracao { $$ = $1; }
               | atribuicao { $$ = $1; }
               | regra_mostrar { $$ = $1; }
               | regra_leia { $$ = $1; }
               | chamada_de_funcao ';' { $$ = $1; }
               ;

declaracao: tipo identificador ';' 
          { 
              $$ = new Armazenar($2, nullptr, $1->astLabel(), true); 
          }
          | tipo identificador '=' expressao ';'
          { 
              $$ = new Armazenar($2, $4, $1->astLabel(), true); 
          }
          | tipo identificador '[' expressao ']' ';' { $$ = new No("DeclaracaoArray"); }
          | tipo identificador '[' expressao ']' '=' expressao ';' { $$ = new No("DeclaracaoArray"); }
          | tipo identificador '[' expressao ']' '[' expressao ']' ';' { $$ = new No("DeclaracaoMatriz"); }
          | tipo identificador '[' expressao ']' '[' expressao ']' '=' expressao ';' { $$ = new No("DeclaracaoMatriz"); }
          ;

atribuicao: identificador '=' expressao ';'
          { 
             $$ = new Armazenar($1, $3, "", false); 
          }
          | identificador '[' expressao ']' '=' expressao ';' { $$ = new No("AtribuicaoArray"); }
          | identificador '[' expressao ']' '[' expressao ']' '=' expressao ';' { $$ = new No("AtribuicaoMatriz"); }
          ;

tipo: tipo_inteiro { $$ = new No("tipo_inteiro"); }
    | tipo_inteiro_longo { $$ = new No("tipo_inteiro_longo"); }
    | tipo_racional { $$ = new No("tipo_racional"); }
    | tipo_racional_longo { $$ = new No("tipo_racional_longo"); }
    | tipo_caractere { $$ = new No("tipo_caractere"); }
    | tipo_boleano { $$ = new No("tipo_boleano"); }
    ;

expressao: expressao_ou { $$ = $1; }
         ;

expressao_ou: expressao_e { $$ = $1; }
            | expressao_ou ou expressao_e { $$ = new OperacaoBinaria($1, "ou", $3); }
            ;

expressao_e: expressao_comparacao { $$ = $1; }
           | expressao_e e expressao_comparacao { $$ = new OperacaoBinaria($1, "e", $3); }
           ;

expressao_comparacao: expressao_aritmetica { $$ = $1; }
                    | expressao_aritmetica operador_comparacao expressao_aritmetica 
                    { 
                      $$ = new OperacaoBinaria($1, $2->astLabel(), $3);
                    }
                    ;

expressao_aritmetica: termo { $$ = $1; }
                    | expressao_aritmetica '+' termo { $$ = new OperacaoBinaria($1, "+", $3); }
                    | expressao_aritmetica '-' termo { $$ = new OperacaoBinaria($1, "-", $3); }
                    ;

termo: fator { $$ = $1; }
     | termo '*' fator { $$ = new OperacaoBinaria($1, "*", $3); }
     | termo '/' fator { $$ = new OperacaoBinaria($1, "/", $3); }
     ;

fator: '(' expressao ')' { $$ = $2; }
     | operador_unario fator 
     { 
       $$ = new OperacaoBinaria(nullptr, $1->astLabel(), $2);
     }
     | valor { $$ = $1; }
     ;

operador_unario: '+' { $$ = new No("+"); }
               | '-' { $$ = new No("-"); }
               | nao { $$ = new No("nao"); }
               ;

valor: numero_inteiro { $$ = new ConstanteInteiro($1); }
     | numero_racional { $$ = new ConstanteRacional($1); }
     | verdadeiro { $$ = new ConstanteInteiro(1); }
     | falso { $$ = new ConstanteInteiro(0); }
     | texto { $$ = new No("texto"); }
     | caractere { $$ = new No("caractere"); }
     | acesso_variavel { $$ = $1; }
     | chamada_de_funcao { $$ = $1; }
     ;

acesso_variavel: identificador { $$ = new Carregar($1); }
               | identificador '[' expressao ']' { $$ = new No("AcessoArray"); }
               | identificador '[' expressao ']' '[' expressao ']' { $$ = new No("AcessoMatriz"); }
               ;

operador_comparacao: igual { $$ = new No("=="); }
                   | diferente { $$ = new No("!="); }
                   | menor_igual { $$ = new No("<="); }
                   | maior_igual { $$ = new No(">="); }
                   | '<' { $$ = new No("<"); }
                   | '>' { $$ = new No(">"); }
                   ;

comando_se_correspondente: se '(' expressao ')' comando_correspondente senao comando_correspondente
                         { $$ = new Se($3, $5, $7); }
                         ;

comando_se_aberto: se '(' expressao ')' comando
                 { $$ = new Se($3, $5); }
                 | se '(' expressao ')' comando_correspondente senao comando_aberto
                 { $$ = new Se($3, $5, $7); }
                 ;

comando_para_correspondente: para '(' para_inicializacao ';' para_condicao ';' para_incremento ')' comando_correspondente
                           { $$ = new Para($3, $5, $7, $9); }
                           ;

comando_para_aberto: para '(' para_inicializacao ';' para_condicao ';' para_incremento ')' comando_aberto
                   { $$ = new Para($3, $5, $7, $9); }
                   ;

para_inicializacao: declaracao_sem_pv { $$ = $1; }
                  | atribuicao_sem_pv { $$ = $1; }
                  | expressao { $$ = $1; }
                  | { $$ = new No("vazio"); }
                  ;

para_condicao: expressao { $$ = $1; }
             | { $$ = new No("vazio"); }
             ;

para_incremento: expressao { $$ = $1; }
               | { $$ = new No("vazio"); }
               ;

declaracao_sem_pv: tipo identificador 
                 { 
                     $$ = new Armazenar($2, nullptr, $1->astLabel(), true); 
                 }
                 | tipo identificador '=' expressao 
                 { 
                     $$ = new Armazenar($2, $4, $1->astLabel(), true); 
                 }
                 | tipo identificador '[' expressao ']' { $$ = new No("DeclarandoArray"); }
                 | tipo identificador '[' expressao ']' '=' expressao { $$ = new No("DeclarandoArray"); }
                 | tipo identificador '[' expressao ']' '[' expressao ']' { $$ = new No("DeclarandoMatriz"); }
                 | tipo identificador '[' expressao ']' '[' expressao ']' '=' expressao { $$ = new No("DeclarandoMatriz"); }
                 ;

atribuicao_sem_pv: identificador '=' expressao 
                  { 
                      $$ = new Armazenar($1, $3, "", false); 
                  }
                  | identificador '[' expressao ']' '=' expressao { $$ = new No("AtribuiçãoArray"); }
                  | identificador '[' expressao ']' '[' expressao ']' '=' expressao { $$ = new No("AtribuiçãoMatriz"); }
                  ;

comando_enquanto_correspondente: enquanto '(' expressao ')' comando_correspondente
                               { $$ = new Enquanto($3, $5); }
                               ;

comando_enquanto_aberto: enquanto '(' expressao ')' comando_aberto
                       { $$ = new Enquanto($3, $5); }
                       ;

comando_composto: '{' lista_comandos '}' { $$ = $2; }
                ;

regra_mostrar: mostrar '(' mostrar_argumentos ')' ';'
            { $$ = new Mostrar($3); }
            ;

mostrar_argumentos: expressao { $$ = $1; }
                  | texto ',' lista_argumentos { $$ = new No("MostrarTexto"); }
                  ;

regra_leia: leia '(' leia_destino ')' ';'
         { 
           $$ = new No("Leia");
           $$->append($3);
         }
         ;

leia_destino: identificador { $$ = new Carregar($1); }
            | identificador '[' expressao ']' { $$ = new No("LeiaArray"); }
            | identificador '[' expressao ']' '[' expressao ']' { $$ = new No("LeiaMatriz"); }
            ;

chamada_de_funcao: identificador '(' argumentos_opcionais ')'
               { $$ = new No("ChamadaDeFuncao"); }
               ;

argumentos_opcionais: 
                    { $$ = new ListaComandos(); }
                    | lista_argumentos { $$ = $1; }
                    ;

lista_argumentos: expressao
                { $$ = new ListaComandos($1); }
                | lista_argumentos ',' expressao
                { $1->append($3); $$ = $1; }
                ;

%%

int yywrap()
{
    return 1;
}

int yyerror(const char *s)
{
    contadorDeErros++;
    printf("Erro encontrado na linha (%d), %s \n", obterLinhaDoErro(), s);
    return 1;
}

int main()
{
    yyparse();
    return 0;
}
