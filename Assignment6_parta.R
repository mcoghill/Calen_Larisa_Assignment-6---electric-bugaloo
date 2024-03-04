install.packages("bcdata")
library(bcdata)
library(mapview)
library(tidyverse)
library(sf)
library(dplyr)
library(ggplot2)

ldb <- bcdc_query_geodata("1130248f-f1a3-4956-8b2e-38d29d3e4af7", crs = 3005) |> 
  filter(PROTECTED_LANDS_NAME == "LAC DU BOIS GRASSLANDS PROTECTED AREA") |> 
  collect()

fire_search <- bcdc_search("fire incident locations")
fire_search

search_id <- grep("fire-incident-locations-historical", names(fire_search))

flayer <- fire_search[[search_id]]
firepoints <- bcdc_query_geodata(flayer$id, crs = 3005) %>% 
  filter(BBOX(ldb)) %>% 
  collect() %>% 
  st_intersection(st_geometry(ldb))

fire_summary <- firepoints %>% 
  group_by(FIRE_YEAR) %>% 
  summarise(count = n()) 

ldbfire_summary <- firepoints %>% 
  group_by(FIRE_CAUSE) %>% 
  summarise(count = n())

mapview(firepoints, zcol = "FIRE_CAUSE")

fire_summary2 <- firepoints %>% 
  group_by(FIRE_CAUSE, FIRE_YEAR) %>% 
  summarise(n = n())


ggplot() +
  geom_boxplot(data = fire_summary2, aes(x = FIRE_CAUSE, y = n)) +
  labs(x = "Fire Cause", y = "Mean Fires per Year") +
  scale_fill_discrete(name = "Fire Cause") +
  theme_minimal()
class(fire_summary2$FIRE_CAUSE)

<<<<<<< HEAD
#austonmatthews is the NHLs best goal scorer
#quinnhughes always looks sad
#brady is a rat
#the oilers are going to win the stanely cup
#vegas will be out in the first round
=======
#elias pettersson is a dreamboat
#auston matthews has a 5 head
#can u teach me how to dougie
#plz plz plz plz plz plz 
#line 5
>>>>>>> 29e1639c717ad196da13f81614ace7558c6cfaab
