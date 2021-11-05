Projeto da disciplina: Introdução ao uso de dados geoespaciais no R
# G5-Pitangatuba

Componentes
Ariane Ferreira
Ingridi Franceschi
Maira Prestes
Mariana Murakami
Talita Menger Ribeiro

Fruta: Pitangatuba

Tarefa 1: Criar um github

Tarefa 2: O que é a pitangatuba: Myrtaceae arbustiva do gênero Eugenia. Natural e endêmica dos litorais do Rio de Janeiro e Espírito Santo.

Tarefa 3: Projeto abaixo

DATA PAPER: BRAZIL ROAD-KILL: a data set of wildlife terrestrial vertebrate road-kills

Ideia do projeto: verificar como os atropelamentos de mamíferos de médio porte estao relacionados com a distância de recursos hídricos e de vegetação nativa ao longo da BR-050.

Hipóteses: 

1. Os atropelamentos de mamíferos de médio e grande porte na rodovia BR-050 são influenciados pela proximidade dos corpos da água e de fragmentos florestais.

2. O número de fatalidades é maior em trechos mais próximos de fragmentos florestais e corpos d'água

Como analisaremos: Usaremos dados disponíveis no datapaper de vertebrados atropelados em estradas “Brazil road-kill” para verificar os registros de atropelamentos. Também consultaremos os dados de massa corpórea do datapaper “Atlantic mammal traits” para definir espécies de médio porte, que serão as selecionadas para as nossas análises.

Tarefas: 

Dividir a BR-050 em segmentos (500m)
Plotar os atropelamentos dos mamíferos
Os segmentos serão caracterizados com contagens dos atropelamentos 
Medir distância dos segmentos para fragmentos florestais
Medir distância dos segmentos para corpos d’água
Fazer um glm:
Variável resposta: número de atropelamentos
Variáveis explanatórias: distância para fragmentos florestais e distância para corpos d’água 
GLM: número de atrop mamíferos ˜ dist_veget * dist_agua

Quais análises estatísticas faremos?
GLM com distribuição poisson/binomial negativa

Como mediremos a distância  e a densidade florestal? 
Distância para água: acho que a função seria st_distance (vetor e vetor).
Distância para floresta: acho que é a função raster::distance (vetor e raster).


