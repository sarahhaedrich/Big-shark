library(tidyverse)
library(tidytext)
library(tidycensus)
library(stringr)
library(readxl)
library(viridis)
library(leaflet)
library(geojsonio)
library(ggplot2)
library(shiny)
library(tigris)
library(dplyr)

########################################## Background Code #############################################

## Census API Key / Installation
# key <- c("850041a1292d809a716eb5556ec09fde5dff8941")
# Sys.getenv("CENSUS_API_KEY")
# census_api_key(key, install = TRUE, overwrite = TRUE)
# readRenviron("~/.Renviron")

## Download the data with the "get_acs" function
# insurance.nyc <- get_acs(geography = "tract", table= "S2701", state = "NY", geometry = TRUE, output = "wide", year = 2017, cache_table = TRUE) 
## Make a copy of the data! (never edit the original)
# insurance.nyc.two <- insurance.nyc


# Upload the American Community Survey data into R Studio
insurance.2017 <- read_csv("ACS_17_5YR_S2701.csv")

# Extract columns with desired data
insurance.2017.two <- insurance.2017[,c("GEO.id", "GEO.id2", "GEO.display-label", "HC03_EST_VC44", "HC03_EST_VC45", "HC03_EST_VC46","HC03_EST_VC47", "HC03_EST_VC75", "HC03_EST_VC76", "HC03_EST_VC77", "HC03_EST_VC78", "HC03_EST_VC79")]

# Rename columns to facilitate code writing
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


# Download geometry for NY county tracts
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

## Join the census table data with the tracts geometry using "GEOID"
insurance.2017.merged<- geo_join(tracts, insurance.2017.two, "GEOID", "GEOID")

#Make a copy
insurance.2017.merged2 <- insurance.2017.merged

# Read in debt data
debt <- read_excel("debt_medical.xlsx")

# Read in NYC county codes data in order to join with debt data
codes <- read_csv("NewYork.csv")

#Name columns appropriately
names(codes)[3] <- "county"
names(codes)[2] <- "fip"
names(codes)[7] <- "GEOID"

# Join data
join.fip <- left_join(debt,
                      codes,
                      by = "county")

#Name columns appropriately
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
unlist(join.fip)

#Join debt data with insurance data
debt.merged <- geo_join(insurance.2017.merged2, join.fip, "GEOID", "GEOID")

##################################### SHINY APP ################################################

ui <- fluidPage(
    mainPanel(tabsetPanel(type = "tabs",
              tabPanel("Part 1: Citizen Status and Insurance Rate",
                       selectInput(inputId = "variable",
                                   label = "Select Citizenship Status",
                                   choices = colnames(insurance.2017.two[4:7])),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       leafletOutput("citizen"),
                       br(),
                       br(),
                       leafletOutput("citizencity"),
                       br(),
                       br()),
              tabPanel("Part 2: Income and Insurance Rate",
                       selectInput(inputId = "range",
                                   label = "Select Income Range",
                                   choices = c("Under 25,000" = "Income1", "25,000 - 49,999" = "Income2", "50,000 - 74,999" = "Income3", "75,000 - 100,000" = "Income4", "Over 100,000" = "Income5")),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       leafletOutput("income"),
                       br(),
                       br(),
                       leafletOutput("incomecity"),
                       br(),
                       br()),
              tabPanel("Part 3: Exploring Medical Debt",
                       leafletOutput = ("debt"),
                       br(),
                       br(),
                       leafletOutput = ("debtcity"),
                       br(),
                       br())
              )))


server <- function(input, output) {
    
  output$citizen <- renderLeaflet({
      
      bins1 <- c(0,70,75,80,85,90,95,Inf)
    colors1 <- colorBin(palette = "YlOrRd",
                        bins = bins1,
                        domain = debt.merged@data[,input$variable])
    
    
    debt.merged%>%
        leaflet()%>%
        addTiles()%>%
        addPolygons(fillColor = ~colors1(get(input$variable)), 
                    weight = .5, 
                    color = "white",
                    dashArray = "3",
                    opacity = 1,
                    fillOpacity = .7)%>%
        addLegend(pal = colors1,
                  values = ~get(input$variable),
                  title = NULL)%>%
      setView(-75.333, 42.7128, zoom = 6)

})
  
  
  
  
  output$citizencity <- renderLeaflet({
    
    bins1 <- c(0,70,75,80,85,90,95,Inf)
    colors1 <- colorBin(palette = "YlOrRd",
                        bins = bins1,
                        domain = debt.merged@data[,input$variable])
    
    
   debt.merged%>%
      leaflet()%>%
      addTiles()%>%
      addPolygons(fillColor = ~colors1(get(input$variable)), 
                  weight = .5, 
                  color = "white",
                  dashArray = "3",
                  opacity = 1,
                  fillOpacity = .7)%>%
      addLegend(pal = colors1,
                values = ~get(input$variable),
                title = NULL)%>%
      setView(-73.8642, 40.705368, zoom = 10)
    
  })



output$income <- renderLeaflet({
  
  bins1 <- c(0,70,75,80,85,90,95,Inf)
  colors2 <- colorBin(palette = "YlGnBu",
                      bins = bins1,
                      domain = debt.merged@data[,input$range])
  
  
  debt.merged%>%
    leaflet()%>%
    addTiles()%>%
    addPolygons(fillColor = ~colors2(get(input$range)), 
                weight = .5, 
                color = "white",
                dashArray = "3",
                opacity = 1,
                fillOpacity = .7)%>%
    addLegend(pal = colors2,
              values = ~get(input$range),
              title = NULL)%>%
    setView(-75.333, 42.7128, zoom = 6)
  
  
  
  
})

output$incomecity <- renderLeaflet({
  
  bins1 <- c(0,70,75,80,85,90,95,Inf)
  colors2 <- colorBin(palette = "YlGnBu",
                      bins = bins1,
                      domain = debt.merged@data[,input$range])
  

  debt.merged%>%
    leaflet()%>%
    addTiles()%>%
    addPolygons(fillColor = ~colors2(get(input$range)), 
                weight = .5, 
                color = "white",
                dashArray = "3",
                opacity = 1,
                fillOpacity = .7)%>%
    addLegend(pal = colors2,
              values = ~get(input$range),
              title = NULL)%>%
    setView(-73.8642, 40.705368, zoom = 10)
  
})

output$debt <- renderLeaflet({
  
  bins3 <- c(0,.05, .1,.15,.20,.25, .30, .35, Inf)
  colors3 <- colorBin(palette = "PuRd",
                      bins = bins3,
                      domain = debt.merged@data$percent.medical.debt)
  
  
  debt.merged%>%
    leaflet()%>%
    addTiles()%>%
    addPolygons(fillColor = colors3, 
                weight = .5, 
                color = "white",
                dashArray = "3",
                opacity = 1,
                fillOpacity = .7)%>%
    addLegend(pal = colors1,
              values = ~percent.medical.debt,
              title = NULL)%>%
    setView(-73.8642, 40.705368, zoom = 6)


})

# output$debtcity <- renderLeaflet({
  
#  bins3 <- c(0,.05, .1,.15,.20,.25, .30, .35, Inf)
 # colors3 <- colorBin(palette = "PuRd",
  #                    bins = bins3,
   #                   domain = debt.merged@data[,input$factor])
  
  
 # debt.merged%>%
  #  leaflet()%>%
   # addTiles()%>%
    #addPolygons(fillColor = ~colors3(get(input$factor)), 
     #           weight = .5, 
      #          color = "white",
       #         dashArray = "3",
        #        opacity = 1,
         #       fillOpacity = .7)%>%
#    setView(-96, 37.8,3)%>%
 #   addLegend(pal = colors1,
  #            values = ~get(input$factor),
   #           title = NULL)%>%
    #setView(-73.8642, 40.705368, zoom = 10)
  
  
## })

}




shinyApp(ui = ui, server = server)
