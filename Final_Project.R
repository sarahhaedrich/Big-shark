install.packages("tidyverse")
install.packages("tidytext")
install.packages("tidycensus")
install.packages("stringr")
install.packages("readxl")
install.packages("viridis")
install.packages("leaflet")

library(tidyverse)
library(tidytext)
library(tidycensus)
library(stringr)
library(readxl)
library(viridis)
library(leaflet)
library(geojsonio)
library(ggplot2)
library(readxl)
library(rsvg)
library(rgdal)
library(magick)
library(stringr)
library(rvest)
library(tigris)


########################################## DOWNLAOD #############################################3

## key <- c("850041a1292d809a716eb5556ec09fde5dff8941")
## Sys.getenv("CENSUS_API_KEY")
## census_api_key(key, install = TRUE, overwrite = TRUE)
## readRenviron("~/.Renviron")


## acs <- load_variables(2017, "acs5", cache = TRUE)
## View(acs)

## insurance.nyc <- get_acs(geography = "tract", table= "S2701", state = "NY", geometry = TRUE, output = "wide", year = 2017) 

insurance.2017 <- read_csv("ACS_17_5YR_S2701.csv")

insurance.2017.two <- insurance.2017[,c("GEO.id", "GEO.id2", "GEO.display-label", "HC03_EST_VC44", "HC03_EST_VC45", "HC03_EST_VC46","HC03_EST_VC47", "HC03_EST_VC75", "HC03_EST_VC76", "HC03_EST_VC77", "HC03_EST_VC78", "HC03_EST_VC79")]

names(insurance.2017.two)[2] <- "GEOID"
names(insurance.2017.two)[4] <- "Native"
names(insurance.2017.two)[5] <- "Foreign"
names(insurance.2017.two)[6] <- "Naturalized"
names(insurance.2017.two)[7] <- "NonCitizen"
names(insurance.2017.two)[8] <- "Income1"
names(insurance.2017.two)[9] <- "Income2"
names(insurance.2017.two)[10] <- "Income3"
names(insurance.2017.two)[11] <- "Income4"
names(insurance.2017.two)[12] <- "Income5"

View(insurance.2017.two)

tracts <- tracts(state = 'NY', county = c(
  001,
  003,
  005,
  007,
  009,
  011,
  013,
  015,
  017,
  019,
  021,
  023,
  025,
  027,
  029,
  031,
  033,
  035,
  037,
  039,
  041,
  043,
  045,
  047,
  049,
  051,
  053,
  055,
  057,
  059,
  061,
  063,
  065,
  067,
  069,
  071,
  073,
  075,
  077,
  079,
  081,
  083,
  085,
  087,
  089,
  091,
  093,
  095,
  097,
  099,
  101,
  103,
  105,
  107,
  109,
  111,
  113,
  115,
  117,
  119,
  121,
  123), cb=TRUE)
View(tracts)

insurance.2017.merged<- geo_join(tracts, insurance.2017.two, "GEOID", "GEOID")
insurance.2017.merged2 <- insurance.2017.merged

debt <- read_excel(file.choose())
View(debt)

codes <- read_csv(file.choose())
View(codes)
names(codes)[3] <- "county"
names(codes)[2] <- "fip"
names(codes)[7] <- "GEOID"


join.fip <- left_join(debt,
                      codes,
                      by = "county")

names(join.fip)[2] <- "state"
names(join.fip)[3] <- "percent.total.debt"
names(join.fip)[6] <- "median.total.debt"
names(join.fip)[9] <- "percent.medical.debt"
names(join.fip)[12] <- "median.medical.debt"
names(join.fip)[16] <- "no.insurance.total"
names(join.fip)[17] <- "no.insurance.white"
names(join.fip)[18] <- "no.insurance.nonwhite"
names(join.fip)[19] <- "average.income"
names(join.fip)[20] <- "average.income.white"
names(join.fip)[21] <- "average.income.nonwhite"


data.frame(join.fip) 
View(join.fip)

debt.merged <- geo_join(insurance.merged2, join.fip, "GEOID", "GEOID")

View(debt.merged)
View(county)


################ Mapping #######################################


bins1 <- c(0,70,75,80,85,90,95,Inf)
colors1 <- colorBin(palette = "YlOrRd",
                    bins = bins1,
                    domain = insurance.merged@data$NonCitizen)


debt.2017.merged%>%
  leaflet()%>%
  addTiles()%>%
  addPolygons(fillColor = ~colors1(NonCitizen), 
              weight = 2, 
              color = "white",
              dashArray = "3",
              opacity = 1,
              fillOpacity = .7)%>%
  setView(-96, 37.8,3)%>%
  addLegend(pal = colors1,
            values = ~NonCitizen,
            title = NULL) %>%
  setView(-75.333, 42.7128, zoom = 6)






