::Sarah Haedrich: Hydrology major to analyze DEM grid to produce hillshade and channel network analysis

::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=hill_

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\lab04\hill_

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%

:: Run Hillshade tool
saga_cmd ta_lighting 0 -ELEVATION=mos5Mosaic_reclassified.sgrd -SHADE=%od%/%pre%hillshade.sgrd

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE