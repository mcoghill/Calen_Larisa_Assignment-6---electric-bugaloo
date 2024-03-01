#libraries
library(bcdata)
library(bcmaps)
library(readxl)
library(sf)
library(tidyverse)
library(mapview)
#Get Lac du Bois layer 
ldb <- bcdc_query_geodata("1130248f-f1a3-4956-8b2e-38d29d3e4af7", crs = 3005) |> 
  filter(PROTECTED_LANDS_NAME == "LAC DU BOIS GRASSLANDS PROTECTED AREA") |> 
  collect()
bc_bec <- bec(force = TRUE)
View(bc_bec)
ldb_bec <- sf::st_intersection(bc_bec, ldb)
mapview(bc_bec)
mapview(ldb_bec)
#•	Calculate the total area of each of the resulting features in hectares.
ldb_bec <- ldb_bec %>% 
  mutate(
    area_ha = FEATURE_AREA_SQM/10000
  )


#•	Create a bar plot where the “MAP_LABEL” column is along the X-axis, and the area is along the Y-axis. Display each bar using different colors.
ggplot() +
  geom_bar(data = ldb_bec, aes(x = MAP_LABEL, y = area_ha, fill = MAP_LABEL), stat = "identity") +
  labs(title = "Area of Ecological Zones in Lac du Bois Provincial Park", 
       x = "Ecological Zone", 
       y = "Area (ha)")

#•	Extract the mean elevation of each of the features (you will need to pull in the DEM from the “cded_terra” function)
?cded_terra
ldb_dem <-cded_terra(aoi = ldb_bec)
mapview(ldb_dem)
ldb_bec <- terra::extract(
  ldb_dem, ldb_bec, fun = mean, na.rm = TRUE, bind = TRUE) %>% 
  st_as_sf()
ldb_bec$elevation

#•	Create a mapview of the BEC vector layer, coloring the polygons by their subzone label.
?mapview
mapview(ldb_bec, zcol= "SUBZONE")
