#' ---
#' title: modelos glm para ver relação das variáveis com os atropelamentos na br050
#' author:grupo pitangatuba
#' date: 04/11/2021
#' ---

modelo <- glm(seg_fatal ~ dist_agua + dist_flo,
            family = poisson(link=log), data = dados_glm)
summary(modelo)
