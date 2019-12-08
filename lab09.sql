
Select * from spatial_ref_sys where srid = 102004

SELECT AddGeometryColumn ('public', 'dorian','geom', 102004, 'POINT', 2, false)
UPDATE dorian
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004)

SELECT AddGeometryColumn ('public', 'nomber','geom', 102004, 'POINT', 2, false)
UPDATE november
SET geom = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004)

UPDATE counties SET geometry = st_transform(geometry,102004);

DELETE FROM counties
WHERE statefp NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01')

SELECT COUNT(status_id)
FROM november
GROUP BY geoid 

ALTER TABLE counties
ADD COLUMN novembercount integer 

ALTER TABLE counties
ADD COLUMN doriancount integer 

UPDATE counties
SET novembercount = 0 

UPDATE counties
SET doriancount = 0

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

ALTER TABLE counties
ADD COLUMN tweetrate real 

UPDATE counties
SET tweetrate = ((novembercount/"POP")*10000*1.0000) 

ALTER TABLE counties
ADD COLUMN ntdi real 

UPDATE counties
SET ntdi = ((doriancount - novembercount) *1.000))/((doriancount + novembercount) *1.000)

UPDATE counties
SET ntdi = 0 WHERE ntdi is null

CREATE TABLE centroids
SELECT *, st_centroid(geometry)
FROM counties
