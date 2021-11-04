#' ---
#' title: selecionando os dados que vamos utilizar
#' author:ingridi franceschi
#' date: 01/11/2021
#' ---

#pacotes necessarios para rodar esse script
library(here)
library(tidyverse)
library(readxl)

###### entrando com o dataset de roadkill
dados_roadkill <- readr::read_csv(here::here("Dataset", "Brazil_Roadkill_20180527.csv"),
                         locale = readr::locale(encoding = "latin1"))

###### entrando com o dataset de traits - ja entrando com a media para as especies
dados_traits <- readr::read_csv(here::here("Dataset", "ATLANTIC_TR_means.csv"),
                         locale = readr::locale(encoding = "latin1"))

###### filtrando os dados de roadkill
dados_obs <- dados_roadkill %>% 
  filter(Class == "Mammalia") %>% # filtrando apenas mamiferos
  count(Road_ID) #observando quantos registros tem em cada rodovia

dados_filter <- dados_roadkill %>% 
  filter(Class == "Mammalia",#selecionando apenas mamiferos
         Road_ID == "BR_050", #selecionando apenas a rodovia BR050
         Reference_ID == "Carvalho_etal_2015") %>% #selecionando apenas uma referencia para os dados serem mais consistente 
  dplyr::select(c(4,5,7,10,13,14,21,22,23,24)) %>%  #selecionando apenas as colunas importantes e que vamos utilizar
  drop_na(Family) #excluindo os registros sem identificação a nivel de familia

###### filtrando os dados de traits
dados_traits_filter <- dados_traits %>% 
  dplyr::select(c(2,3,6,10,11)) %>% 
  rename(Scientific_name = binomial,
         Order = order) #renomeando o nome da coluna para poder juntar na etapa seguinte por esta coluna

###### juntando os dados filtrados dos dois datapapers para podermos selecionar as especies de medio e grande porte
dados_esp <- dados_filter %>% 
  left_join(., dados_traits_filter, by = c("Scientific_name", "Order")) %>% 
  filter(is.na(Group) | Group == "Large mammals") %>%  #selecionando apenas os mamiferos de medio e grande porte, baseado na classificacao do datapaper trais, 
                                                  #mas tb no conhecimento das especies/familias, pois algumas especies no datapaper roadkill nao estao no outro
  mutate(record_ok = case_when(Family == "Didelphidae" ~ "excluir", #criei uma coluna para poder excluir as linhas de didelphidae, pois sao esp < 1kg
            TRUE ~ "ok")) %>%  #no caso aqui apenas indiquei quais linhas estao ok e quais devem ser excluidas
  filter(record_ok == "ok") %>%  #aqui ficou apenas as linhas ok, sem didelphidae
  dplyr::select(-record_ok) #aqui to excluindo essa coluna porq nao precisamos mais

dados_esp #esse é o conjunto final que vamos utilizar para analisar
  


