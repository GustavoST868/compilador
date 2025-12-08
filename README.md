# Compilador

Analisador léxico, sintático e semântico desenvolvido para estudo dos princípios de construção de compiladores. O projeto lê um código-fonte, identifica tokens, valida a estrutura conforme a gramática definida e realiza verificações semânticas básicas.

## Descrição

Este projeto implementa as três primeiras etapas clássicas de um compilador:

1. **Análise Léxica** – Identificação dos tokens presentes no código-fonte.
2. **Análise Sintática** – Construção da árvore conforme a gramática definida.
3. **Análise Semântica** – Verificação de consistência e regras semânticas.

O repositório também contém exemplos de entrada e imagens das árvores sintáticas geradas.

## Objetivo

Servir como base para estudos sobre construção de compiladores, incluindo:

- Estruturação de um pipeline completo (léxico → sintático → semântico)
- Criação de gramáticas
- Construção de árvores sintáticas
- Leitura e validação de código-fonte

## ⚙️ Funcionalidades

✔️ Tokenização (LEX / Flex)  
✔️ Parsing baseado em gramática (YACC / Bison)  
✔️ Construção de árvore sintática  
✔️ Regras semânticas básicas  
✔️ Programas de teste incluídos  
✔️ Geração automatizada via Makefile  

## 📁 Estrutura do Projeto
/
├── analisadorLexico.l # Regras do analisador léxico

├── analisadorSintatico.y # Gramática e análise sintática/semântica

├── nodes.h # Estruturas dos nós utilizados nas árvores

├── Makefile # Automação de compilação

├── imagens-das-arvores/ # Diagramas/prints das árvores geradas

└── programas-de-teste/ # Arquivos para testar o compilador

## 🔧 Pré-requisitos

Antes de compilar, instale:

- `gcc` (ou outro compilador C)
- `flex` / `lex`
- `bison` / `yacc`
- `make`




