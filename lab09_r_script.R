library(igraph)
library(dplyr)
library(tidytext)
library(tm)
library(tidyr)
library(ggraph)
library(tidycensus)
library(ggplot2)
library(RPostgres)
library(RColorBrewer)
library(DBI)
library(rccmisc)


#Connectign to Postgres
#Create a con database connection with the dbConnect function.
#Change the database name, user, and password to your own!
con <- dbConnect(RPostgres::Postgres(), dbname='sarah', host='artemis', user='sarah', password='Yellow12!') 

#list the database tables, to check if the database is working
dbListTables(con) 

View(dorian)
View(november)

#create a simple table for uploading
dorian.upload <- select(dorian,c("user_id","status_id","text","lat","lng"),starts_with("place"))
november.upload <- select(november, c("user_id","status_id","text","lat","lng"),starts_with("place"))

#write data to the database
#replace new_table_name with your new table name
#replace dhshh with the data frame you want to upload to the database 
dbWriteTable(con,'Dorian',dorian.upload, overwrite=TRUE)
dbWriteTable(con,'November',november.upload, overwrite=TRUE)

#SQL to add geometry column of type point and crs NAD 1983: 
#SELECT AddGeometryColumn ('public','winter','geom',4269,'POINT',2, false);
#SQL to calculate geometry: update winter set geom = st_transform(st_makepoint(lng,lat),4326,4269);

#make all lower-case names for this table
necounties <- lownames(NorthEastCounties)
dbWriteTable(con,'necounties',necounties, overwrite=TRUE)
#SQL to update geometry column for the new table: select populate_geometry_columns('necounties'::regclass);

#disconnect from the database
dbDisconnect(con)