# Lab 07 & Lab 08: Malawi Vulnerability Assessment: Looking at Reproducibility and Replicability


The goals of this lab are to test the reproducability of a multi-criteria analysis of vulnerability in Malawi by [Malcolm, Weaver, and Krakowka, 2014](VulnerabilityMalcolm.pdf).

# Data

Demographic Health Surveys - conducted by the U.S. Agency for International Development (USAID) from 2004-2010
DHS Cluter Points
Traditional Authority Tracts
Flood Risk and Exposure to Drought from the UNEP Global Risk
GADM Malawi boundaries 
FEWSnet Livelihood Zones

# Goals

![Figure 4](Figure4.png)

Figure 4 shows the average resilience score in the traditional authorities. The first Figure 4 shows data from 2004, and the second Figure 4 shows data from 2010. These average resilience scores were calculated by assigning each category from the DHS surveys a value, 1 through 5. The scores were then aggregated with the flood risk and drought risk data downloaded from the UNEP Global Risk data and weighted according to the following figure:

![Image](MalcolmMethod.png)


Replicate 80% of Figure 5 - we are unable to access 20% of the data used for this map in our time span. We hope to replicate what we can given the accessible data. 
![Figure 5](Figure5.png)


# Malcolm et. al's Methodolgy

In order to conceptalize Malcomb et al.'s method, we sketched a workflow in class. Below is an image of the workflow:
![Image](MalcombMCE.jpeg)



# Our attempt to reproduce Figure 4

The DHS surveys are available to people after an application process. Our professor, Joe Holler, received the DHS survey data, however, due to due to the privacy regulations around the data, the students were not able to work with the data. However, each student in the class was assigned a variable from the table above to write an SQL code to classify the DHS survey data into quantiles. Professor Holler then accumulated our work into this [SQL code](vulnerabilitySQL (1).sql). This SQL file will, in theory, produce a figure that resembles Figure 4. in Malcolm, et al.'s vulnerability analysis.

![](Figure5_smallercellsize.PNG)


# Our attempt to reproduce Figure 5

To reproduce Figure 5 in which Malcolm et al. produced a map of vunerability to climate change, we used this [model](vulnerability.model3) to calculate vulnerability created by our professor, Joe Holler. 

Below is a screen shot of the working model:

![Image](Model_1_Biggercellsize.PNG)

The model above creates the map below:

![Image](Figure_5_Bigger_Cell.PNG)

In Malcolm's Figure 5, it is evident that Malcolm used a smaller cell size (0.416666) rather then the bigger cell size we used in our model (0.833333). Therefore, in order to replicate Malcolm's outcomes, I added a parameter in the model to allow the user to input a cell size. Below is a screen shot of the working model with the added parameter:

![Image](Model_2_Smallercellsize.PNG)








# Discussion


Cell Size: Malcolm et al. used a cell size of 0.416666, which does not match the cell size of the traditional authorities layer. Therefore, this would produce an error seeing as Malcolm added specificity to data which didn't actually exist in the layer. Our map, with a cell size of 0.8333 retains the integrity of the original data.

Quantiles: Malcolmb et al. stated that each DHS survey category was broken into quantiles, meaning the scores in each category were assigned a value from 1 through 5. Lower values represent low resiliency/more vulnerability, and high values represent high resiliency/low vulnerability. As a class, we could not figure out how Malcomb assigned quantile scores to boolean data. For example, the category "owns a cell phone" is boolean data because the answers consist of either "yes" or "no." Grouping "yes" or "no" data into quantiles is not logical. No where in the paper did Malcolmb explicity explain how boolean data was incorporated into the adaptative capacity scores. Furthermore, one of my classmates, [Robert Kelley](https://rmkelley.github.io/) mentioned that Malcolmb et al. mentioned the use of quantiles, implying 1 - 5 grouping, but in another section of the paper mentioned grouping the data from 0-5. This sort of detail is crucial for the reproducibility of the study. 










