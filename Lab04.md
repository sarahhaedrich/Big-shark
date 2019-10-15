## Lab 04


In Lab 4, I used batch script files to preform the same hydrological analysis as Lab 3. To start, I downloaded the DEM files and the NUM files for both SRTM data and ASTER data [here](https://earthdata.nasa.gov/). The DEM file (Digital Elevation Model) contains elevation data in a raster layer. The NUM files contains the source of each data point in the DEM file, also displayed as a raster layer. For example, the orange in the SRTM NUM file represents DEM data sourced from ASTER data. 

# Here are the SRTM DEM Files:

![SRTM DEM Visualization](SRTM_DEM.png) ![](SRTM_DEM_legend.png)



![SRTM NUM Visualization](SRTM_NUM.png) ![](SRTM_NUM_legend.png)


# And here are the ASTER Files:


![ASTER DEM Visualization](ASTER_DEM.png) ![](ASTER_DEM_legend.png)


![ASTER NUM Visualization](ASTER_N.png) ![](ASTER_N_legend.png)


The first two steps in the hydrological analysis was to mosaick the two tiles together into one grid, and then reproject the mosaicked grid into the UTM projection. After this step, we are able to look at the difference between the ASTER DEM files and the SRTM DEM files. I used the "Grid Difference" tool in Saga to preform this step.

# Here is the SRTM data subtracted from the ASTER Data:

![(ASTER DEM) - (SRTM DEM)](Difference(ASTER_SRTM).png) ![](Difference(ASTER_SRTM)_legend.png)


After these initial steps, I preformed a hillshade analysis using the [hillshade batch script](Hillshade.bat).

# Here is the hillshade analysis of Mt. Kilomanjaro using the batch script with SRTM data:

![SRTM Hillshade](SRTM_Hillshade.png) ![](SRTM_Hillshade_legend.png)


# Here is the hillshade analysis of Mt. Kilomanjaro using the ASTER data:

![Aster Hillshade](ASTER_Hillshade.png) ![](ASTER_Hillshade_legend.png)

Here is the [channel network batch script](ChannelNetworkSRTM.bat) I wrote to preform the hydrological analysis of Mt. Kilomanjaro.
