all:
	flex analisadorLexico.l
	bison -d analisadorSintatico.y
	g++ -o compilador analisadorSintatico.tab.c lex.yy.c -lfl
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "Compilador criado. O nome do meu compilador é \"compilador\"."
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "TESTES SEM ERROS"
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com definição de estruturas:"
	./compilador < programas-de-teste/programas-sem-erros/definicoes.g
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "Programa com condicional:"
	./compilador < programas-de-teste/programas-sem-erros/condicional.g
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com laço de repetição:"
	./compilador < programas-de-teste/programas-sem-erros/laco.g
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "TESTES COM ERROS"
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro de definição:"
	./compilador < programas-de-teste/programas-com-erros/definicoes.g
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro em condicional:"
	./compilador < programas-de-teste/programas-com-erros/condicional.g
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro no laço de repetição:"
	./compilador < programas-de-teste/programas-com-erros/laco.g
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "As verificações semânticas implementadas são:"
	@echo "- Variável declarada mas não usada;"
	@echo "- Variável usada mais não declarada;"  
	@echo "- Erro de atribuição de tipo."
	@echo "--------------------------------------------------------"
	@echo ""
	@echo "TESTES COM ERROS SEMÂNTICOS"
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro semântico de variável declarada mais não usada:"
	./compilador < programas-de-teste/programas-verificacao-semantica/variavel-declarada-mas-nao-usada.g
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro semântico de variável usada mas não declarada:"
	./compilador < programas-de-teste/programas-verificacao-semantica/variavel-nao-declarada-mas-usada.g 
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "Programa com erro semântico de atribuição com tipo incorreto:"
	./compilador < programas-de-teste/programas-verificacao-semantica/atribuicao-int-float.g 
	@echo ""
	@echo "--------------------------------------------------------"
