#' ---
#' title: modelos glm para ver relação das variáveis com os atropelamentos na br050
#' author:grupo pitangatuba
#' date: 04/11/2021
#' ---
library(MASS)
library(performance)
library(see)

#modelo glm com distribuição binomial negativa (vatiável resposta contagem)
#testar se a distancia dos segmentos da rodovia para corpos dagua e floresta 
#influencia nos atropelamentos de mamíferos de medio e grande porte (br 050)
modelo <- glm.nb(seg_fatal ~ min.dist_agua*min.dist_flo, data = dados_glm)
summary(modelo)
plot(modelo)

#The overdispersion statistic can be calculated
ods <- modelo$deviance / modelo$df.residual; ods #underdispersion

#usando os pacotes performance e see para checar a sobredispersao e residuos
#check_overdispersion(modelo) #como foi binomial negativa nao ve sobredispersao
check_model(modelo)

# validacao do modelo pelos residuos
Fitted <- fitted(modelo)
Resid <- resid(modelo, type = "pearson")
par(mfrow = c(1,1), mar = c(5,5,2,2))
plot(x = Fitted, y = Resid,
     xlab = "Fitted values",
     ylab = "Pearson Residuals")
abline(h = 0, lty = 2)


