# G5-Pitangatuba
Projeto da disciplina: Introdução ao uso de dados geoespaciais no R

Fruta: pitangatuba

Tarefa 1: Criar um github pra nósssssss 

Tarefa 2: O que é a pitangatuba: Myrtaceae arbustiva do gênero Eugenia. Natural e endêmica dos litorais do Rio de Janeiro e Espírito Santo.

Tarefa 3: Projeto abaixo

DATA PAPER: BRAZIL ROAD-KILL: a data set of wildlife terrestrial vertebrate road-kills

Ideia do projeto: verificar como a presença de atropelamentos de mamíferos de médio porte está relacionada com a distância de recursos hídricos, distância para vegetação nativa e densidade florestal ao longo da BR-050.

Hipótese: A presença de atropelamentos de mamíferos de médio porte em segmentos ao longo da rodovia BR-050 é influenciada pela quantidade de floresta, e proximidade dos corpos da água e de fragmentos florestais. 

Como analisaremos: Usaremos dados disponíveis no datapaper de vertebrados atropelados em estradas “Brazil road-kill” para verificar os registros de atropelamentos. Também consultaremos os dados de massa corpórea do datapaper “Atlantic mammal traits” para definir espécies de médio porte, que serão as selecionadas para as nossas análises.

Dividir a BR-050 em segmentos (definir o tamanho de acordo com o n de atropelamentos que tivermos - 500m talvez seja bom)
Plotar os atropelamentos dos mamíferos
Os segmentos serão caracterizados como com e sem a presença de atropelamentos 
Medir distância dos segmentos para fragmentos florestais
Medir distância dos segmentos para corpos d’água
Medir a densidade de floresta ao redor dos segmentos (definir tamanho do buffer, talvez 5km seja o suficiente, avaliar)
Fazer um glm:
Variável resposta: presença de atropelamentos
Variáveis explanatórias: distância para fragmentos florestais, distância para corpos d’água e densidade florestal
Algo assim: presença de atrop mamíferos ˜ dist_veget * dist_agua * dens_veget

Quais análises estatísticas faremos?
GLM binomial

Como mediremos a distância  e a densidade florestal? 
Distância para água: acho que a função seria st_distance (vetor e vetor).
Distância para floresta: acho que é a função raster::distance (vetor e raster).
Densidade de floresta em buffer: pensar, mas acho que tem que contar o número de pixel floresta dentro do buffer e dividir pela área do buffer.

