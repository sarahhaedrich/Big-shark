--- NUMBER OF SCHOOLS BY SUBWARD - DAR ES SALAAM ---
--- Sarah Haedrich and Marco van Gemeren ---

-- Select all points and polygons representing schools (where amenity="school")
ALTER TABLE planet_osm_polygon ADD COLUMN intersectsPoint Interger
UPDATE planet_osm_polygon
SET intersectsPoint = 1
FROM planet_osm_point
WHERE amenity = 'school'AND st_intersect(planet_osm_polygon.way, planet_osm_point.way)

-- Select school points intersecting school polygons
SELECT * FROM planet_osm_polygon WHERE intersectsPoint = 1

-- Create centroids of school polygons intersecting points
SELECT osm_id, name, amenity, st_centroid(st_transform(way, 32727)), intersectsPoint
FROM planet_osm_polygon
WHERE amenity = 'school' and intersectpoint is NULL

-- Combine (union) school polygon centroids with school points (and convert to UTM 27S projection)
CREATE TABLE mergedSchools AS
SELECT osm_id, amenity, st_centroid FROM pointlessSchools2
UNION
SELECT osm_id, amenity, st_transform(way, 32727) FROM planet_osm_point
WHERE amenity = 'school'

-- Filtering out schools with blank names.
CREATE TABLE nonBlank_Schools AS
SELECT * FROM mergedSchools
WHERE name <> ""

-- Group by school name (for schools with duplicate names).
CREATE TABLE groupedSchools AS
SELECT st_centroid(st_union(st_centroid)), trim(upper(name)) FROM nonBlank_Schools
GROUP BY trim(upper(name))

-- To avoid merging all schools with blank names, blank-named schools are added in after merging duplicates.
CREATE TABLE remergedSchools AS
SELECT btrim AS name, st_centroid as geom FROM groupedSchools
UNION
SELECT name, st_centroid as geom FROM blankschools

-- Create new column for schools containing the ward the school is in.
UPDATE remergedSchools
SET ward = subwards.fid
FROM subwards
WHERE st_intersects(remergedSchools.geom, st_transform(subwards.geom, 32727))

-- Summing up the number of schools in each ward.
CREATE TABLE schoolWard as
SELECT ward, count(*) as schoolCount FROM remergedSchools
GROUP BY ward