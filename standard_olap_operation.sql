-- PART 1 - Target: 9 Queries
/**
2 Queries for drill down and roll up
***/

-- Revenue budget and profit by continent
SELECT c.continentName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = b.movie_id AND f.date_id = d.date_id AND 
b.productionCountry_id = c.productionCountry_id
GROUP BY c.continentName;

/* Revenue, budget and profit by production country where the film was released in December 2010 */
SELECT c.countryName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = sb.movie_id AND f.date_id = d.date_id AND 
sb.productionCountry_id = c.productionCountry_id AND d.year = 2010 AND d.month = 12
GROUP BY c.countryName
ORDER BY total_profit DESC;

-- Number of films in each continent released in 2010
SELECT c.continentName, count(f.movie_id) AS films_released, sum(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = sb.movie_id AND sb.productionCountry_id = c.productionCountry_id AND f.date_id = d.date_id AND d.year = 2010
GROUP BY c.continentName
ORDER BY total_profit DESC;

-- Number of films in each country released in 2010 Q4
SELECT c.countryName, count(f.movie_id) AS films_released, sum(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = sb.movie_id AND sb.productionCountry_id = c.productionCountry_id AND f.date_id = d.date_id 
AND d.year = 2010 AND d.quarter = 'Q4'
GROUP BY c.countryName
ORDER BY total_profit DESC;

/* Revenue budget and profit by continent */
SELECT c.continentName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` b, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.movie_id = b.movie_id AND b.productionCountry_id = c.productionCountry_id
GROUP BY c.continentName;

/* Revenue, budget and profit by company name filmed in USA and released in 2010 Q1 */
SELECT s.companyName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionStudio-Movie-bridgeTable` sb, `ProductionCountry-Movie-bridgeTable` cb, 
ProductionStudio s, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = sb.movie_id AND sb.productionStudio_id = s.productionStudio_id
AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id AND c.countryName = 'United States of America'
AND f.date_id = d.date_id AND d.year = 2010 AND d.quarter IN ('Q1')
GROUP BY s.companyName
ORDER BY total_profit DESC;

-- 1 Slice query
-- 2 Dice queries

-- 4 Combinational queries (combination of any/all of the above)

-----------------------------
-- PART 2 - Target: 3 Queries

-- Iceberg Query

-- Windowing Query

-- Window Clause