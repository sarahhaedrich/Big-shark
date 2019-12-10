# Lab 07 & Lab 08: Malawi Vulnerability Assessment: Looking at Reproducibility and Replicability


The goals of this lab are to test the reproducability of a multi-criteria analysis of vulnerability in Malawi based off the paper by [Malcolm, Weaver, and Krakowka, 2014](VulnerabilityMalcolm.pdf).

We hope to replicate Figure 4 and 80% of Figure 5 since we are unable to access 20% of the data used for this map in our time span. 


![Figure 4](Figure4.png)
![Figure 5](Figure5.png)

# Data
The data for this lab is attached [here](mwi_data.zip).

Authors:
Timing:
CRS:
EXTENT:
Spatial Resolution:
Uncertainty & Sampling:

# Malcolm et. al's Methodolgy

# Step 1

Load UNEP Global Risk data into PostGIS
1. From the UNEP folder in the mwi_data.zip file, download the .tif files for estimated flood risk for flood hazard and the exposition to drought events.
2. Create a batch script for running raster2pgsql plug-in (found in QGIS) in order to convert the raster data into SQL code. Save the file in the same location as the .tif files, add appropriate flags ("-s," "-t," "-d"), and then end the command line with the name of the raster tif, the table name, and the name of the SQL file (nameofraster.tif public.tablename > nameofSQLfile.sql).
3. Run program! A SQL file should have been created. If so, add another line in the batch script for another raster. 
4. Load the SQL files of rasters into database.  












