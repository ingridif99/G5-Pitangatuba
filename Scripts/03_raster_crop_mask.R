#' ---
#' title: cortando raster da rodovia para o trecho que tem atropelamentos
#' author: G5 - Pitangatuba
#' date: 03/11/2021
#' ---



#pacotes necessarios para rodar esse script
library(here)
library(tidyverse)
library(sf)
library(raster)


#### visualizando o raster da paisagem entorno da rodovia
raster <- raster::raster(here::here("Variaveis", "vegetacao", "mapbiomas_2013.tif"))
plot(raster)

##### entrando com o shape da rodovia do google mymaps
br050_y <- st_read(here::here("Variaveis", "rodovias", "br050_buffer.shp"), quiet = TRUE)
plot(br050_y) #visualizando o shapefile

#ajustando e cortando o raster com base no shapefile - novo trecho da rodovia
road_crop_mask <- raster %>% 
  crop(br050_y) %>% 
  mask(br050_y)

plot(road_crop_mask) #visualizando


# exportar raster layer
raster::writeRaster(road_crop_mask, 
                    filename = here::here("Variaveis", "vegetacao", "raster_veg_road"),
                    format = "GTiff",
                    datatype = "INT2S",
                    options = c("COMPRESS=DEFLATE", "TFW=YES"),
                    progress = "text",
                    overwrite = TRUE)
