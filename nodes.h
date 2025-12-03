#include <vector>
#include <string>
#include <iostream>
#include <set>

extern int yylineno;

using namespace std;

//utilizei uma struct para guardar o nome do simbolo e o tipo relacionado a ele
struct Simbolo {
    string nome;
    string tipo;

    bool operator<(const Simbolo& outro) const {
        return nome < outro.nome;
    }
};

class No {
protected:
    vector<No*> children;
    int lineno;
    // variavel que guarda o rotulo do nó
    string astLabelValue;

public:
    No() {
        lineno = yylineno;
        astLabelValue = "No";
    }

    No(const string& label) {
        lineno = yylineno;
        astLabelValue = label;
    }

    int getLineNo() {
        return lineno;
    }

    void append(No *n) {
        if (n) {
            children.push_back(n);
        }
    }

    const vector<No*>& getChildren() const {
        return children;
    }
    
   //fiquei em duvida quanto ao uso do virtual, mas vi que ele permite o polimorfismo em tempo de execucao
    virtual string astLabel() {
        return astLabelValue;
    }

    virtual ~No() {}
};

class NoIdentificador : public No {
protected:
    string nome;
public:
    NoIdentificador(const string& nome) : nome(nome) {
        // caso eu descomente, no nó relacionado ao identificador, aparece o texto entre aspas
        //astLabelValue = "Identificador: " + nome;
        astLabelValue = "" + nome;
    }
    
    string getNome() const { return nome; }
};

class Carregar: public No {
protected:
    string nome;
public:
    Carregar(string nome) {
        this->nome = nome;
        astLabelValue = "" + nome;
    }
    
    string obterNome(){
        return nome;
    }
};

// class relacionada ao no de Load
class Armazenar: public No {
protected:
    string nome;
    string tipo; 
    bool ehDeclaracao;
public:
    
    Armazenar(string nome, No *expr, string tipoDeclarado = "", bool ehDeclaracao = true) {
        this->nome = nome;
        this->ehDeclaracao = ehDeclaracao;
        this->tipo = tipoDeclarado;
        
        if (ehDeclaracao) {
            astLabelValue = "Declaracao: " + nome;
        } else {
            astLabelValue = "Atribuicao: " + nome;
        }
        if (expr) {
            this->append(expr);
        }
    }
    
    string obterNome() {
        return nome;
    }
    
    string obterTipo() {
        return tipo;
    }
    
    bool getEhDeclaracao() {
        return ehDeclaracao;
    }
};

class ConstanteInteiro: public No {
protected:
    int valor;
public:
    ConstanteInteiro(int valor) {
        this->valor = valor;
        astLabelValue = " " + to_string(valor);
    }
};

class ConstanteRacional: public No {
protected:
    double valor;
public:
    ConstanteRacional(double valor) {
        this->valor = valor;
        astLabelValue = "" + to_string(valor);
    }
};

class OperacaoBinaria: public No {
protected:
    string operador;
public:
    OperacaoBinaria(No *esquerda, const string& operador, No *direita) {
        this->operador = operador;
        astLabelValue = " " + operador;
        if (esquerda) this->append(esquerda);
        if (direita) this->append(direita);
    }
};

class Mostrar: public No {
public:  
    Mostrar(No *expr) {
        astLabelValue = "Mostrar";
        if (expr) this->append(expr);
    }
};

class ListaComandos: public No {
public: 
    ListaComandos() {
        astLabelValue = "ListaDeComandos";
    }
    
    ListaComandos(No *comando) {
        astLabelValue = "ListaDeComandos";
        if (comando) this->append(comando);
    }
    
    void append(No *comando) {
        if (comando) {
            No::append(comando);
        }
    }
};

class Se: public No {
public:
    Se(No *condicao, No *comandoIf, No *comandoElse = nullptr) {
        astLabelValue = "Se";
        if (condicao) this->append(condicao);
        if (comandoIf) this->append(comandoIf);
        if (comandoElse) this->append(comandoElse);
    }
};

class Enquanto: public No {
public:
    Enquanto(No *condicao, No *comando) {
        astLabelValue = "Enquanto";
        if (condicao) this->append(condicao);
        if (comando) this->append(comando);
    }
};

class Para: public No {
public:
    Para(No *inicializacao, No *condicao, No *incremento, No *comando) {
        astLabelValue = "Para";
        if (inicializacao) this->append(inicializacao);
        if (condicao) this->append(condicao);
        if (incremento) this->append(incremento);
        if (comando) this->append(comando);
    }
};

class Programa: public No {
protected: 
    void imprimirArvoreRecursiva(No *n, int &contador) {
        if (!n) return;
        
        cout << "  N" << contador << " [label=\"" << n->astLabel() << "\"];\n";
        int idAtual = contador;
      
        for(No *c : n->getChildren()) {
            if (c) {
                contador++;
                cout << "  N" << idAtual << " -- N" << contador << ";\n";
                imprimirArvoreRecursiva(c, contador);
            }
        }
    }

public: 
    Programa(No *listaComandos) {
        astLabelValue = "Programa";
        if (listaComandos) this->append(listaComandos);
    }
    
    void imprimirArvore() {
        cout << "\ngraph{\n";
        cout << "";
        
        int contador = 0;
        cout << "  N" << contador << " [label=\"Programa\"];\n";
        
        if (!getChildren().empty() && getChildren()[0]) {
            contador++;
            cout << "  N0 -- N" << contador << ";\n";
            imprimirArvoreRecursiva(getChildren()[0], contador);
        }
        
        cout << "}\n";
    }
};

// verificacao semantica em variaveis
class VerificacaoSemanticaDeclaracao {
private:
    set<string> variaveisDeclaradas;  
    set<string> variaveisUsadas;     
    
public:
    void check(No *n) {
        if(!n) return;

        for(No *c : n->getChildren()) {
            check(c);
        }

        Armazenar *armazenar = dynamic_cast<Armazenar*>(n);
        if (armazenar != NULL) {
            string nomeVariavel = armazenar->obterNome();
            if (armazenar->getEhDeclaracao()) {
                variaveisDeclaradas.insert(nomeVariavel);
            }
        }
        
        Carregar *carregar = dynamic_cast<Carregar*>(n);
        if (carregar != NULL) {
            string nomeVariavel = carregar->obterNome();
            variaveisUsadas.insert(nomeVariavel);
        }
    }

    void verificarTodasVariaveis() {
        cout << "";
        bool temProblemas = false;
        
        for(const string& variavel_usada : variaveisUsadas) {
            if (variaveisDeclaradas.count(variavel_usada) == 0) {
                cout << "erro semantico: variavel '" << variavel_usada << "' usada mas nao declarada.\n";
                temProblemas = true;
            }
        }
        
        for(const string& variavel_declarada : variaveisDeclaradas) {
            if (variaveisUsadas.count(variavel_declarada) == 0) {
                cout << "erro semantico: variavel '" << variavel_declarada << "' declarada mas nao usada.\n";
                temProblemas = true;
            }
        }
        if (!temProblemas) cout << "\n";
    }
};

// classe de verificacao semantica de tipos
class VerificacaoSemanticaTipos {
private:
    set<Simbolo> tabelaSimbolos; 

    
    string buscarTipoVar(string nome) {
        
        Simbolo busca; 
        busca.nome = nome;
        
        auto it = tabelaSimbolos.find(busca);
        if (it != tabelaSimbolos.end()) {
            return it->tipo;
        }
        return "indefinido";
    }

public:

    //o metodo olha os dois nós, da esquerda e da difeita, e olha o tipo correto a ser retornado
    string inferirTipo(No *n) {
        if (!n) return "indefinido";

        if (dynamic_cast<ConstanteInteiro*>(n)) return "tipo_inteiro";
        if (dynamic_cast<ConstanteRacional*>(n)) return "tipo_racional";
        if (n->astLabel() == "verdadeiro" || n->astLabel() == "falso") return "tipo_boleano";

        
        Carregar *carregar = dynamic_cast<Carregar*>(n);
        if (carregar) {
            return buscarTipoVar(carregar->obterNome());
        }

       
        OperacaoBinaria *op = dynamic_cast<OperacaoBinaria*>(n);
        if (op) {
            string tipoNoEsquerda = "indefinido";
            string tipoNoDireita = "indefinido";
            
            const vector<No*>& filhos = n->getChildren();
            if (filhos.size() > 0) tipoNoEsquerda = inferirTipo(filhos[0]);
            if (filhos.size() > 1) tipoNoDireita = inferirTipo(filhos[1]);

            
            // no c++ e na biblioteca string, o trecho string::npos é usado para representar "nenhuma posição encontrada"  
            //aqui rotulo seria o label referente a astLabel do nó       
            string rotulo = n->astLabel();
            if (rotulo.find("==") != string::npos || rotulo.find("!=") != string::npos ||
                rotulo.find("<") != string::npos || rotulo.find(">") != string::npos ||
                rotulo.find("e") != string::npos || rotulo.find("ou") != string::npos) {
                return "tipo_boleano";
            }

           //mediante aos tipos relacionados, retorna o tipo
            if (tipoNoEsquerda == "tipo_racional" || tipoNoDireita == "tipo_racional") return "tipo_racional";
            if (tipoNoEsquerda == "tipo_inteiro" && tipoNoDireita == "tipo_inteiro") return "tipo_inteiro";
            
            return tipoNoEsquerda;
        }

        return "indefinido";
    }

    void check(No *n) {
        if (!n) return;

        Armazenar *armazenar = dynamic_cast<Armazenar*>(n);
        
        if (armazenar) {
            string nomeVar = armazenar->obterNome();
            
            if (armazenar->getEhDeclaracao()) {
               
                string tipo = armazenar->obterTipo();
                Simbolo novoSimbolo;
                novoSimbolo.nome = nomeVar;
                novoSimbolo.tipo = tipo;
                
              // ao pesquisar o que era o .erase(), diz que é para eliminar elementos de estruturas  
                if (tabelaSimbolos.count(novoSimbolo)) {
                    tabelaSimbolos.erase(novoSimbolo);
                }
                tabelaSimbolos.insert(novoSimbolo);
                
               
                if (n->getChildren().size() > 0) {
                     string tipoExpr = inferirTipo(n->getChildren()[0]);
                     if (tipoExpr != "indefinido") {
                         if (tipo == "tipo_inteiro" && tipoExpr == "tipo_racional") {
                             cout << "erro semantico na linha " << n->getLineNo() << ": "
                                  << "atribuição de racional para inteiro '" << nomeVar << "'.\n";
                         }
                     }
                }
            } else {
                string tipoEsperado = buscarTipoVar(nomeVar);
                
                if (tipoEsperado != "indefinido") {
                    if (n->getChildren().size() > 0) {
                        string tipoExpr = inferirTipo(n->getChildren()[0]);
                        
                        if (tipoEsperado == "tipo_inteiro" && tipoExpr == "tipo_racional") {
                             cout << "erro semantico na linha " << n->getLineNo() << ": "
                                  << "atribuição de racional para inteiro '" << nomeVar << "'.\n";
                        }
                    }
                }
            }
        }

        for(No *c : n->getChildren()) {
            check(c);
        }
    }
};
