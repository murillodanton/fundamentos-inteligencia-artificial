"""
rede_neural.py
Fundamentos da IA - U4/A4: rede neural de uma camada com ativacao sigmoide.
Treina por aprendizado supervisionado para classificacao binaria.
"""
import numpy as np


# 1. Funcao sigmoide (e sua derivada, quando deriv=True)
def sigmoide(x, deriv=False):
    if deriv:
        # aqui x ja e a saida da sigmoide: s'(z) = s(z) * (1 - s(z))
        return x * (1 - x)
    return 1 / (1 + np.exp(-x))


# 2. Entradas (4 exemplos, 3 atributos) e saida desejada
#    A saida e igual a primeira coluna da entrada.
X = np.array([[0, 0, 1],
              [0, 1, 1],
              [1, 0, 1],
              [1, 1, 1]])
y = np.array([[0, 0, 1, 1]]).T

# 3. Pesos da sinapse inicializados aleatoriamente em [-1, 1]
np.random.seed(1)  # semente fixa para resultados reproduziveis
sinapse = 2 * np.random.random((3, 1)) - 1
print("Pesos iniciais:\n", sinapse)

# 4. Treinamento: 10.000 iteracoes
ITERACOES = 10000
for i in range(ITERACOES):
    camada_entrada = X
    camada_saida = sigmoide(np.dot(camada_entrada, sinapse))   # propagacao para frente
    erro = y - camada_saida                                    # erro
    delta = erro * sigmoide(camada_saida, deriv=True)          # ajuste via derivada
    sinapse += np.dot(camada_entrada.T, delta)                 # atualizacao dos pesos

    if (i + 1) in (1, 10, 100, 1000, 10000):
        print(f"Iteracao {i + 1:>5}: erro medio absoluto = {np.mean(np.abs(erro)):.6f}")

# 5. Resultados com os pesos apos a ultima atualizacao
camada_saida = sigmoide(np.dot(X, sinapse))
print("\nPesos finais:\n", sinapse)
print("\nSaida apos o treinamento:\n", camada_saida)
print("\nClasse prevista (limiar 0,5):", (camada_saida > 0.5).astype(int).ravel())
print("Classe esperada:             ", y.ravel())

# Teste exploratorio: a terceira coluna era constante 1 no treinamento.
# [1, 0, 0] sai desse dominio; nao comprova generalizacao.
# Teste com uma entrada nova
novo = np.array([1, 0, 0])
print("\nEntrada nova [1, 0, 0] ->", sigmoide(np.dot(novo, sinapse)))
