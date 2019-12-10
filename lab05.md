

## Lab 05



In lab 5, I worked with [Marco van Germenen](https://marcovg.github.io/) to develop and execute a vulnerability analysis using our skills in SQL and data from [Open Street Map](https://www.openstreetmap.org/). The goal of this lab was to design and preform a vulnerability analysis which would be accessible and replicable to the public. We chose Dar es Saalam as our focus region since the city is one of the most mapped locations on Open Street Map with special thanks to the [Tanzania Resilience Academy](https://resilienceacademy.ac.tz/). 

For our vulnerability analysis, Marco and I chose to calculate the number of schools per ward in Dar es Saalam in hopes to understand how educational resources are distributed around the region. Wards with a lower number of schools may indicate areas with less access to resources, an indicator of vulnerabilty. Wards with a higher number of schools may indicate neighborhoods with more access to resources. This is a spatial analysis since we are focusing on 




The concept of counting the number of schools per ward seems simple, but ran into some unexpected problems. Therefore, I have outlined our process below. Our final leaflet map is attached [here](dsmmap).

---------------------------------------------------------------------------------------------------------------

Our data from this lab was downloaded from [Tanzania Resilience Academy](https://resilienceacademy.ac.tz/) and [Open Street Map](https://www.openstreetmap.org/). 

The first step involves downlaoding data from [open street map](https://www.openstreetmap.org/) into QGIS. We used these [files] written by our professor, Joe Holler, and proceeded to preform the following steps:
1. Download Open Street Map data by going to [open street map](https://www.openstreetmap.org/) and zooming to the desired    extent. Click "Overpass API" and save the file as a ".osm" file. 
2. Open the convertOSM.bat in Notepad++ and change the database name to your database and the username to your username. Save.
3. Open dsm.style in Notepad++ and edit for the desired tags. In our case, we desired schools tags, so the script looked    like this: 
        "node,way     school      text       linear." 
If polygons are desired, change "linear" to "polygons." If points are desired, change "node,way" to "node."
4. Run the convertOSM.bat and the data will download into the PostGIS database!
  

After downloading our data, we are reading to use SQL to execute our research question. 

# Step 1
We selected for the data that we wanted to use in our analysis. Seeing as we wanted to look at number of schools per ward, we used the SELECT tool WHERE amenity = 'school'. We added, "CREATE VIEW," so we could have a visualize of the data.

Now we run into a little issue here... we have points that represent schools, and polygons that represent schools, and some points represent the same polygons. We will need to find a way to make a layer of points in which every school is
represented by one point.

# Step 2
We used the below query to find all the points (representing schools) which intersected with polygons:

```sql
"ALTER TABLE planet_osm_polygon ADD COLUMN intersectsPoint Interger
UPDATE planet_osm_polygon
SET intersectsPoint = 1
FROM planet_osm_point
WHERE amenity = 'school'AND st_intersect(planet_osm_polygon.way, planet_osm_point.way)
```

Followed by: 
```sql
SELECT * FROM planet_osm_polygon WHERE intersectsPoint = 1
```

# Step 3
We have selected all the points that intersect with a polygon. We now want to take the remaining polygons, which don't intersect with points, and transform the polygons into points (in other words, find the centroid) and reproject the data into the proper coordinate system. 

Here's the query:

```sql
  SELECT osm_id, name, amenity, st_centroid(st_transform(way, 32727)), intersectsPoint
  FROM planet_osm_polygon
  WHERE amenity = 'school' and intersectpoint is NULL
  ```

# Step 4
We now need to join the centroid (representing schools that didn't intersect with points) with the points (representing schools that intersected with polygons). It's important to note that we used the UNION function in this query because we wanted to add rows to rows, not match columns. 

```sql
CREATE TABLE mergedSchools AS
SELECT osm_id, amenity, st_centroid FROM pointlessSchools2
UNION
SELECT osm_id, amenity, st_transform(way, 32727) FROM planet_osm_point
WHERE amenity = 'school'
```
# Step 5
At this point in the query, we identified another issue -- some of the schools have duplicate names! In order to deal with these duplicate, we want to group by "name." However, some of the schools have blank names, so when we use group by, all the schools with blank names are grouped together (one group with over 100 schools representing blank names is not what
we want). So, we are filtering out the blank names before we use the group by function. We then add the blank names back into the non-blank names after we have removed the duplicates.

```sql
CREATE TABLE nonBlank_Schools AS
SELECT * FROM mergedSchools
WHERE name <>""
```

# Step 6
After we removed the blank names, we removed the duplicates by grouping by name and then finding the centroid of the union of the duplicates (looking at the geometry of the duplicate schools and then finding the center point between them).

```sql
CREATE TABLE groupedSchools AS
SELECT st_centroid(st_union(st_centroid)), trim(upper(name)) FROM nonBlank_Schools
GROUP BY trim(upper(name))
```

In this situation, it was really important to add "trim" and "upper" to the function in both parts of the query so the computer would still count schools as duplicates even if the names had difference capital letters and/or spacing.

# Step 7
Now, we need to UNION the blank schools back into the grouped schools table.

```sql
CREATE TABLE remergedSchools AS
SELECT btrim AS name, st_centroid as geom FROM groupedSchools
UNION
SELECT name, st_centroid as geom FROM blankschools
```

In the above query, we need to make sure we have the same number of columns in the two tables we are going to join. To make sure of this, we can specify the columns we want to join ("name", "st_centroid")

# Step 8
We then need to count the number of schools within each ward. To do this, we
first updated our remergedSchools data table and added the ward fid as a new column.

```sql
UPDATE remergedSchools
SET ward = subwards.fid
FROM subwards
WHERE st_intersects(remergedSchools.geom, st_transform(subwards.geom, 32727))
```

# Step 9
Now we want to count up the schools in each ward:

```sql
CREATE TABLE schoolWard as
SELECT ward, count(*) as schoolCount FROM remergedSchools
GROUP BY ward
```

Since we couldn't carry over the geometry while using the "GROUP BY" function, we needed to join the geometry data to the table we just made, making sure to add a new column before we do so. After we made the new column, we added the geometry data to the schoolWard table, and then used "COUNT" to count the number of schools within each SchoolWard. 

After this final step in our SQL query, we then presented our findings as a leaflet file, attached above.

# Conclusion and Discussion



