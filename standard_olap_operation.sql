-- PART 1 - Target: 9 Queries

-- 2 Queries for drill down and roll up
SELECT m.movie_id, m.title, f.budget
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` b, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.movie_id = b.movie_id AND f.date_id = d.date_id AND b.productionCountry_id = c.productionCountry_id
Group BY c.Continent

-- 1 Slice query

-- 2 Dice queries

-- 4 Combinational queries (combination of any/all of the above)

-----------------------------
-- PART 2 - Target: 3 Queries

-- Iceberg Query

-- Windowing Query

-- Window Clause