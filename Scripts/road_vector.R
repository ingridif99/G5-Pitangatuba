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

###### entrando com o shape das rodovias federais
road <- st_read(here::here("Variaveis", "rodovias", "Rodovias.shp"), quiet = TRUE)

#Simple feature collection with 7360 features and 30 fields
#Geometry type: LINESTRING
#Dimension:     XY
#Bounding box:  xmin: -73.70507 ymin: -33.69308 xmax: -32.40022 ymax: 4.482599
#Geodetic CRS:  SIRGAS 2000
                
plot(road$geometry) #visualizando as rodovias federais no brasil

road050 <- road %>% #filtrando apenas a rodovia de interesse BR050
  filter(vl_br == "050")

plot(road050$geometry) #visualizando a nossa rodovia de interesse

road050_x<- road050 %>%  #retirei o anel em Uberlandia para termos a rodovia em linha mesmo
  filter(nm_tipo_tr == "Eixo Principal" |
              nm_tipo_tr == "Acesso" |
              nm_tipo_tr == "Variante")
plot(road050_x$geometry)

br050_ext <- sum(st_length(road050_x)) #extensao em metros da rodovia

br050_union <- st_union(road050_x) #unindo todos os trechos da rodovia em uma linha - all geometries are unioned together
#road050_union <- st_combine(road050_x) # Combine several feature geometries into one, without unioning or resolving internal boundaries

plot(br050_union)

br050 <- st_as_sf(br050_union) #Transformei o objeto multilinestring em espacial.

#as_Spatial(br050) #objeto espacial SP

##### etapa extra para auxiliar no recorte do raster posteriormente
road_buffer <- st_buffer(x = road050$geometry, dist = 15000) #estabelecendo um buffer ao entorno da rodovia para depois recortarmos o raster
plot(road_buffer) #tem varios buffer se sobrepondo porq a rodovia esta dividida em varios trechos

road_union <- st_union(road_buffer) #unindo todos os buffers de cada trecho em um só
plot(road_union) #visualizando 

# exportar o vetor da rodovia na extensão esri shapefile
st_write(obj = road_union, dsn = here::here("Variaveis", "rodovias", "rodovia_br050.shp"))
