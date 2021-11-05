#' ---
#' title: criando dados para glm (contagens de atropelamento por segmentoo, distancia para agua e floresta)
#' author: G5 - Pitangatuba
#' date: 04/11/2021
#' ---



#pacotes necessarios para rodar esse script
library(here)
library(tidyverse)
library(readxl)
library(sf)
library(raster)
library(rgeos)

######## entrando com o shape da rodovia do google mymaps recortado apenas para o trecho que tem os atrop
br050 <- st_read(here::here("Variaveis", "rodovias", "br050_uber.shp"), quiet = TRUE)
plot(br050$geometry) #visualizando a rodovia 050
br050_ext <- sum(st_length(br050)) #extensao em metros da rodovia
br050_geometry <- br050$geometry #selecionou apenas a coluna das coordenadas do df para ser um objeto class spatial lines
br050_sp <- as_Spatial(br050_geometry) #transformando em objeto espacial SP

source(here::here("Scripts", "SegmentSpatialLines_function.R")) #puxando função para dividir br em segmentos

#segmentos de 1.5km na rodovia 
#segments_br050 <- SegmentSpatialLines(br050_sp, length = 0.0135, merge.last = TRUE) # o comprimento na função é dado em metros, nossas coords estão em graus (1grau = 111km)
#plot(segments_br050, col= rainbow(8), lwd=3) #visualizando a estrada segmentada

#segmentos de 500M na rodovia 
segments_br050 <- SegmentSpatialLines(br050_sp, length = 0.0045, merge.last = TRUE) # o comprimento na função é dado em metros, nossas coords estão em graus (1grau = 111km)
plot(segments_br050, col= rainbow(8), lwd=3) #visualizando a estrada segmentada

#buffer de 2km em cada segmento
seg_buffer <- gBuffer(segments_br050, width = 0.0195, byid = TRUE, capStyle = "FLAT", joinStyle = "BEVEL", mitreLimit = 0.01)
plot(seg_buffer, border = "orange")
plot(seg_buffer[19:34,], border = "orange") #visualizar com zoom nesses segmentos


#transformar o arquivo SpatialLine em Linestring
seg_sf <- st_as_sf(seg_buffer)
seg_sf_crs <- seg_sf$geometry %>% 
  st_as_sf(crs = 4326)

# converter sistema de coordenadas da rodovia
seg_road_utm22s <- sf::st_transform(seg_sf_crs, crs = 32722)

#centroide de cada segmento da rodovia
seg_centroide <- st_centroid(seg_road_utm22s)
plot(seg_centroide)
plot(seg_centroide[19:52,])

######## visualizando os pontos das fatalidades 
dados_esp_geom <- dados_esp %>% 
  st_as_sf(coords = c("Long", "Lat"), crs = 4326)

plot(seg_road_utm22s[19:32,], lwd=3) #visualizando a estrada segmentada em segmentos especificos
plot(fatalidades_utm22s$geometry, add = TRUE, pch=20) #visualizando as fatalidades na rodovia

####### contar o numero de fatalidades em cada trecho
# converter sistema de coordenadas das fatalidades
fatalidades_utm22s <- sf::st_transform(dados_esp_geom, crs = 32722)

plot(seg_road_utm22s) #visualizando a rodovia 
plot(fatalidades_utm22s$geometry, add = TRUE) #visualizando as fatalidades em cima da rodovia

seg_fatal <- lengths(st_intersects(seg_road_utm22s, fatalidades_utm22s)) # contando numero de fatalidades em cada trecho

######## visualizando o raster da paisagem entorno da rodovia
raster <- raster::raster(here::here("Variaveis", "vegetacao", "raster_veg_road.tif"))
plot(raster, col = viridis::viridis(10))
nlayers(raster) # numero de camadas
raster::freq(raster) # frequencia das celulas

# selecionar a classe floresta (1)
raster_flo <- raster == 3
plot(raster_flo)

# selecionar a classe agua (33)
raster_agua <- raster == 33
plot(raster_agua)

# vetorizando a classe agua em linha
agua <- rasterToContour(raster_agua)
plot(agua)
agua_sf <- st_as_sf(agua)

# vetorizando a classe floresta em linha
floresta <- rasterToContour(raster_flo)
plot(floresta)
floresta_sf <- st_as_sf(floresta)

# converter sistema de coordenadas da agua
agua_utm22s <- sf::st_transform(agua_sf, crs = 32722)

# converter sistema de coordenadas da floresta
floresta_utm22s <- sf::st_transform(floresta_sf, crs = 32722)

####### calculando a distancia do centroide de cada trecho da rodovia em relação a agua
#dist_agua <- seg_centroide %>% 
 # dplyr::mutate(dist_agua = sf::st_distance(seg_centroide, agua_utm22s)) 

dist_agua <- sf::st_distance(seg_centroide, agua_utm22s)
min.dist_agua <- apply(dist_agua, 1, FUN = min)

####### calculando a distancia do centroide de cada trecho da rodovia em relação a agua
#dist_flo <- seg_centroide %>% 
 # dplyr::mutate(dist_flo = sf::st_distance(seg_centroide, floresta_utm22s))

dist_flo <- sf::st_distance(seg_centroide, floresta_utm22s)
min.dist_flo <- apply(dist_flo, 1, FUN = min)

####### juntanto todos os dados em um df só (floresta, agua e atropelamentos)

dados_glm <- as.data.frame(cbind(seg_fatal, min.dist_agua, min.dist_flo))
 


# exportar o vetor da rodovia segmentada na extensão esri shapefile
st_write(obj = seg_road_utm22s, dsn = here::here("Variaveis", "rodovias", "seg_road_utm22s.shp"))
