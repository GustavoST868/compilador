inteiro contador = 0;
enquanto (contador < 5) {
    mostrar("Contador: ");
    mostrar(contador);
    contador = contador + 1;
}

inteiro outroContador = 10;
enquanto (outroContador > 0) {
    outroContador = outroContador - 1;
    se (outroContador == 5) {
        mostrar("Chegou na metade!");
    }
}

inteiro idx = 0;
enquanto (idx < 10) {
    idx = idx + 1;
}

{
    inteiro varLocal = 100;
    racional pi = 3.14159;
    mostrar("Bloco interno - varLocal: ");
    mostrar(varLocal);
    mostrar(", pi: ");
  
}

inteiro x = 10;
inteiro y = 5;
se (x > 0 e x != pi) {
    enquanto (y < 10) {
        y = y + 1;
    }
}

leia(x);
inteiro vetor[5];
leia(vetor[2]);
inteiro matriz[3][3];
leia(matriz[1][1]);

minhaFuncao(x, y);
outraFuncao();
