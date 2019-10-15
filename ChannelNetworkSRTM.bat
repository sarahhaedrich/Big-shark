::Sarah Haedrich: This model inputs DEM layers to output a channel network analysis. The final channel network layer outputs a grid that shows cells that receive water flow from at least 1000 other cells. This type of analysis allows us to predict where streams will form using the DEM input. We can use a color gradient to show the degree of flow in the water path.

::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=srtm__

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\lab04\srtm_

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%


:: Run Sink Drainage Route Detection
saga_cmd ta_preprocessor 1 -ELEVATION=W:\lab04\mos2Mosaic_reclassified.sgrd -SINKROUTE=%od%/%pre%sinkroutes.sgrd

::Run Sink Removal
saga_cmd ta_preprocessor 2 -DEM=W:\lab04\mos2Mosaic_reclassified.sgrd -SINKROUTE=%od%/%pre%sinkroutes.sgrd -DEM_PREPROC=%od%/%pre%sinksremoved.sgrd -METHOD=1

::Run Flow Accumulation
saga_cmd ta_hydrology 0 -ELEVATION=%od%/%pre%sinksremoved.sgrd -SINKROUTE=%od%/%pre%sinkroutes.sgrd -FLOW=%od%/%pre%flow.sgrd -FLOW_UNIT=0 -METHOD=4 -LINEAR_DO=1 -LINEAR_MIN=500 -CONVERGENCE=1.1

::Run Channel Network
saga_cmd ta_channels 0 -ELEVATION=%od%/%pre%sinksremoved.sgrd -INIT_GRID=%od%/%pre%flow.sgrd -CHNLNTWRK=%od%/%pre%channelnetwork.sgrd -CHNLROUTE=%od%/%pre%channelroute.sgrd -SHAPES=channelshapes.sgrd -INIT_METHOD=2 -INIT_VALUE=1000 -MINLEN=10



::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE