

## Lab 05



In lab 5, Marco and I used data from the [Tanzania Resilience Academy](https://resilienceacademy.ac.tz/) and [Open Street Map](https://www.openstreetmap.org/) to display the number of schools per ward in Dar Es Salaam, Tanzania. The concept of counting the number of schools per ward seems simple, but ran into some unexpected problems. Therefore, I have outlined our process below and attached the leaflet map at the bottom of the page. 

---------------------------------------------------------------------------------------------------------------

Our first step involved using a pre-written batch script from our professor, Joe Holler. We used the batch script convertOSM.bat in the osm_script folder to convert our downloaded OSM files into files appropriate for QGIS. To download open street map files, we went to to [this link](https://www.openstreetmap.org/) and exported the files, making sure to save the downloads as a ".osm" file. 

We then selected for the data that we wanted to use in our analysis. Seeing as we wanted to look at number of schools per ward, we used the SELECT tool WHERE amenity = 'school'. We added, "CREATE VIEW," so we could have a visualize of the data.


Now we run into a little issue here... we have points that represent schools, and polygons that represent schools, and some points represent the same polygons. We will need to find a way to make a layer of points in which every school is
represented by one point.

We used the below query to find all the points (representing schools) which intersected with polygons:

"ALTER TABLE planet_osm_polygon ADD COLUMN intersectsPoint Interger
UPDATE planet_osm_polygon
SET intersectsPoint = 1
FROM planet_osm_point
WHERE amenity = 'school'AND st_intersect(planet_osm_polygon.way, planet_osm_point.way)

Followed by: 
```sql
SELECT * FROM planet_osm_polygon WHERE intersectsPoint = 1
```
We have selected all the points that intersect with a polygon. We now want to take the remaining polygons, which don't intersect with points, and transform the polygons into points (in other words, find the centroid) and reproject the data into the proper coordinate system. 

Here's the query:
  SELECT osm_id, name, amenity, st_centroid(st_transform(way, 32727)), intersectsPoint
  FROM planet_osm_polygon
  WHERE amenity = 'school' and intersectpoint is NULL


We now need to join the centroid (representing schools that didn't intersect with points) with the points (representing schools that intersected with polygons). It's important to note that we used the UNION function in this query because we wanted to add rows to rows, not match columns. 

CREATE TABLE mergedSchools AS
SELECT osm_id, amenity, st_centroid FROM pointlessSchools2
UNION
SELECT osm_id, amenity, st_transform(way, 32727) FROM planet_osm_point
WHERE amenity = 'school'

At this point in the query, we identified another issue -- some of the schools have duplicate names! In order to deal with these duplicate, we want to group by "name." However, some of the schools have blank names, so when we use group by, all the schools with blank names are grouped together (one group with over 100 schools representing blank names is not what
we want). So, we are filtering out the blank names before we use the group by function. We then add the blank names back into the non-blank names after we have removed the duplicates.

CREATE TABLE nonBlank_Schools AS
SELECT * FROM mergedSchools
WHERE name <>""

After we removed the blank names, we removed the duplicates by grouping by name and then finding the centroid of the union of the duplicates (looking at the geometry of the duplicate schools and then finding the center point between them).

CREATE TABLE groupedSchools AS
SELECT st_centroid(st_union(st_centroid)), trim(upper(name)) FROM nonBlank_Schools
GROUP BY trim(upper(name))

In this situation, it was really important to add "trim" and "upper" to the function in both parts of the query so the computer would still count schools as duplicates even if the names had difference capital letters and/or spacing.


Now, we need to UNION the blank schools back into the grouped schools table

CREATE TABLE remergedSchools AS
SELECT btrim AS name, st_centroid as geom FROM groupedSchools
UNION
SELECT name, st_centroid as geom FROM blankschools

In the above query, we need to make sure we have the same number of columns in the two tables we are going to join. To make sure of this, we can specify the columns we want to join ("name", "st_centroid")

We then need to count the number of schools within each ward. To do this, we
first updated our remergedSchools data table and added the ward fid as a new column.

UPDATE remergedSchools
SET ward = subwards.fid
FROM subwards
WHERE st_intersects(remergedSchools.geom, st_transform(subwards.geom, 32727))

Now we want to count up the schools in each ward:

CREATE TABLE schoolWard as
SELECT ward, count(*) as schoolCount FROM remergedSchools
GROUP BY ward

Since we couldn't carry over the geometry in our group by function, we needed to join the geometry data to the table we just made, making sure to add a new column before we do so.

After we make the new column, we added the geometry data to the schoolWard table, and then used COUNT to count the number of schools within each SchoolWard. 

After this final step in our SQL query, we then presented our findings as a leaflet file, attached below.

Here is our final leaflet map:
[Dar Es Salaam](dsmmap)
