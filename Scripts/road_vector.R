#' ---
#' title: selecionando a rodovia que vamos utilizar BR-050
#' author:ingridi franceschi
#' date: 01/11/2021
#' ---

#pacotes necessarios para rodar esse script
library(here)
library(tidyverse)
library(readxl)
library(sf)
library(rgeos)

#OBS: Etapas comentadas abaixo foram a primeira tentativa para importar e segmentar a rodovia que foi substituída pelo códico seguinte (Guardamos para possível consulta)

###### entrando com o shape das rodovias federais
#road <- st_read(here::here("Variaveis", "rodovias", "Rodovias.shp"), quiet = TRUE)
#road050 <- road %>% #filtrando apenas a rodovia de interesse BR050
#  filter(vl_br == "050")
# plot(road050$geometry) #visualizando a nossa rodovia de interesse
# road050_x<- road050 %>%  #retirei o anel em Uberlandia para termos a rodovia em linha mesmo
#filter(nm_tipo_tr == "Eixo Principal" |
#         nm_tipo_tr == "Acesso" |
#         nm_tipo_tr == "Variante")
#plot(road050_x$geometry)
#br050_union <- st_union(road050_x) #unindo todos os trechos da rodovia em uma linha - all geometries are unioned together


##### entrando com o shape da rodovia do google mymaps
br050 <- st_read(here::here("Variaveis", "rodovias", "br050_uber.shp"), quiet = TRUE)

plot(br050$geometry) #visualizando a rodovia 050

br050_ext <- sum(st_length(br050)) #extensao em metros da rodovia

br050_geometry <- br050$geometry #selecionou apenas a coluna das coordenadas do df para ser um objeto class spatial lines

br050_sp <- as_Spatial(br050_geometry) #transformando em objeto espacial SP

source(here::here("Scripts", "SegmentSpatialLines_function.R")) #puxando função para dividir br em segmentos

#segmentos de 500m
segments_br050 <- SegmentSpatialLines(br050_sp, length = 0.0045, merge.last = TRUE) # o comprimento na função é dado em metros, nossas coords estão em graus (1grau = 111km)
plot(segments_br050, col= rainbow(8), lwd=3) #visualizando a estrada segmentada

##### etapa extra para auxiliar no recorte do raster posteriormente
road_buffer <- st_buffer(x = br050$geometry, dist = 15000) #estabelecendo um buffer ao entorno da rodovia para depois recortarmos o raster
plot(road_buffer) #tem varios buffer se sobrepondo porq a rodovia esta dividida em varios trechos

#road_union <- st_union(road_buffer) #unindo todos os buffers de cada trecho em um só
#plot(road_union) #visualizando 

# exportar o vetor da rodovia na extensão esri shapefile
st_write(obj = road_buffer, dsn = here::here("Variaveis", "rodovias", "br050_buffer.shp"))