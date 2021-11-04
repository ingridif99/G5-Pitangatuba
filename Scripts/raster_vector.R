#pacotes necessarios para rodar esse script
library(here)
library(tidyverse)
library(readxl)
library(sf)
library(raster)

##### entrando com o shape da rodovia do google mymaps
br050 <- st_read(here::here("Variaveis", "rodovias", "br050_uber.shp"), quiet = TRUE)
plot(br050$geometry) #visualizando a rodovia 050
br050_ext <- sum(st_length(br050)) #extensao em metros da rodovia
br050_geometry <- br050$geometry #selecionou apenas a coluna das coordenadas do df para ser um objeto class spatial lines
br050_sp <- as_Spatial(br050_geometry) #transformando em objeto espacial SP

source(here::here("Scripts", "SegmentSpatialLines_function.R")) #puxando função para dividir br em segmentos

#segmentos de 5km
segments_br050 <- SegmentSpatialLines(br050_sp, length = 0.045) # o comprimento na função é dado em metros, nossas coords estão em graus (1grau = 111km)
plot(segments_br050, col= rainbow(8), lwd=3) #visualizando a estrada segmentada

##### visualizando os pontos das fatalidades 
dados_esp_geom <- dados_esp %>% 
  st_as_sf(coords = c("Long", "Lat"), crs = 4326)

plot(segments_br050, col= rainbow(8), lwd=3) #visualizando a estrada segmentada
plot(dados_esp_geom$geometry, add = TRUE) #visualizando as fatalidades na rodovia

#### visualizando o raster da paisagem entorno da rodovia
raster <- raster::raster(here::here("Variaveis", "vegetacao", "mapbiomas_2013.tif"))
plot(raster)

# numero de camadas
nlayers(raster)

teste <- subset(raster, "mapbiomas_2013")
plot(mapbio.reclass)

raster_class <- raster::calc(x = raster, fun = function(x) ifelse(x == 1, "agua", NA))

values.reclass <- cbind(c(1,3,4,5,9,10,11,12,13,14,15,18,19,20,21,22,23,24,25,27,29,30,31,32,33,36,39,40,41,46,47,48,49,26),
                        c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,2))

mapbio.reclass <- reclassify(raster, values.reclass)

image(raster)


w <- raster %>% 
  mutate(class_str = str_to_upper(class),
         class_str = case_when(class_str == "3" ~ "FLO",
                               class_str == "4" ~ "SAV",
                               class_str == "5" ~ "MANG",
                               class_str == "9" ~ "SILV",
                               class_str == "11" ~ "CALAG",
                               class_str == "12" ~ "CAMPO",
                               class_str == "13" ~ "NONF",
                               class_str == "14" ~ "AGROP",
                               class_str == "15" ~ "PAS",
                               class_str == "18" ~ "AGRIC",
                               class_str == "20" ~ "CANA",
                               class_str == "21" ~ "AGRPAS",
                               class_str == "22" ~ "NOVEG",
                               class_str == "23" ~ "DUNA",
                               class_str == "24" ~ "URB",
                               class_str == "25" ~ "NONVEG",
                               class_str == "27" ~ "NOBS",
                               class_str == "29" ~ "ROCHA",
                               class_str == "30" ~ "MINER",
                               class_str == "31" ~ "AQUIC",
                               class_str == "32" ~ "APICUM",
                               class_str == "33" ~ "AGUA",
                               class_str == "36" ~ "LAVPER",
                               class_str == "39" ~ "SOJA",
                               class_str == "41" ~ "LAVTEMP",
                               TRUE ~ class_str)








xx <- raster::raster(here::here("Variaveis", "vegetacao", "land_UA282_2018.tif"))
plot(xx)

dem_rc_crop_mask <- raster %>% 
  raster::crop(rc_2020) %>% 
  raster::mask(rc_2020)
dem_rc_crop_mask








x <- map(segments_br050, function(x){
  x %>% 
    st_distance(dados_esp_geom)
  
}
  