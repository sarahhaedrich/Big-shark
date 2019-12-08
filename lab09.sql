/* Double check to see if projection 102004 was read in correctly */
Select * from spatial_ref_sys where srid = 102004

/* Add point geometry to twitter data sets */
SELECT AddGeometryColumn ('public', 'dorian','geom', 102004, 'POINT', 2, false)
UPDATE dorian
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004)

SELECT AddGeometryColumn ('public', 'nomber','geom', 102004, 'POINT', 2, false)
UPDATE november
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004)

/* Transform the counties data set into the 102004 projection system */
UPDATE counties SET geometry = st_transform(geometry,102004);

/* Delete counties we don't need */
DELETE FROM counties
WHERE statefp NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01')

/* Add new column of text data to twitter data sets */
ALTER TABLE dorian ADD COLUMN geoid varchar(5);
ALTER TABLE november ADD COLUMN geoid varchar(5)

/* Set new column equal to the geoid of the county the tweet intersects with */
UPDATE dorian
SET geoid = (SELECT GEOID from counties
WHERE st_intersects(geom, counties.geometry))

UPDATE november
SET geoid = (SELECT GEOID from counties
WHERE st_intersects(geom, counties.geometry))

/* Add new column of data type integer to twitter data sets */
ALTER TABLE counties
ADD COLUMN novembercount integer 

ALTER TABLE counties
ADD COLUMN doriancount integer 

/* Set the column equal to 0 (in order to avoid any "NULL" data) */
UPDATE counties
SET novembercount = 0 

UPDATE counties
SET doriancount = 0

/* Group by county and count the number of tweets per county */
UPDATE counties
SET novembercount = (SELECT COUNT(status_id)
FROM november
WHERE st_intersects(counties.geometry, november.geom)
GROUP BY geoid) 

UPDATE counties
SET doriancount = (SELECT COUNT(status_id)
FROM dorian
WHERE st_intersects(counties.geometry, dorian.geom)
GROUP BY geoid)

/* Add new column of data type "real" */
ALTER TABLE counties
ADD COLUMN tweetrate real 

/* Calculate the number of tweets per 10,000 people per county */ 
UPDATE counties
SET tweetrate = ((doriancount/"POP")*10000*1.0000)

/* Add new column of data type "real" */
ALTER TABLE counties
ADD COLUMN tweetrate real 

/* Calculate the number of tweets per 10,000 people per county */ 
UPDATE counties
SET tweetrate = ((doriancount/"POP")*10000*1.0000)ALTER TABLE counties

/* Add new column of data type "real */
ALTER TABLE counties 
ADD COLUMN ntdi real 

/* Find the normalized difference between dorian tweets and november tweets */
UPDATE counties
SET ntdi = (((doriancount - novembercount) *1.000)/((doriancount + novembercount) *1.000))
WHERE doriancount+novembercount >0

/* Set the "null" values to "0" */
UPDATE counties
SET ntdi = 0 WHERE ntdi is null

/* Find centroids of counties to use for heat map / kernal density map of twitter activity */
CREATE TABLE centroids
SELECT *, st_centroid(geometry)
FROM counties
