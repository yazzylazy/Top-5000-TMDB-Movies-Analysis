-- PART 1 - Target: 9 Queries
/**
2 Queries for drill down and roll up
***/

/* Number of films in each continent in 2010 (Rollup) */
SELECT c.continentName, count(f.movie_id) AS films_released
FROM MovieFactTable f, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = sb.movie_id AND sb.productionCountry_id = c.productionCountry_id AND f.date_id = d.date_id AND d.year = 2010
GROUP BY c.continentName;

/* Revenue budget and profit by continent (Rollup) */
SELECT c.continentName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = b.movie_id AND f.date_id = d.date_id AND 
b.productionCountry_id = c.productionCountry_id
GROUP BY c.continentName;

/* Revenue, budget and profit by production country where the film was released in December 2010  (Drill-down) */
SELECT c.countryName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` sb, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = sb.movie_id AND f.date_id = d.date_id AND 
sb.productionCountry_id = c.productionCountry_id AND d.year = 2010 AND d.month = 12
GROUP BY c.countryName
ORDER BY total_profit DESC;

/* Revenue, budget and profit by company name filmed in USA and released in 2010 Q1 (Drill-down) */
SELECT s.companyName, sum(revenue) AS total_revenue, sum(budget) AS total_budget, sum(revenue-budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionStudio-Movie-bridgeTable` sb, `ProductionCountry-Movie-bridgeTable` cb, 
ProductionStudio s, ProductionCountry c, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.movie_id = sb.movie_id AND sb.productionStudio_id = s.productionStudio_id
AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id AND c.countryName = 'United States of America'
AND f.date_id = d.date_id AND d.year = 2010 AND d.quarter IN ('Q1')
GROUP BY s.companyName
ORDER BY total_profit DESC;

/** 
1 Slice Operation
**/

/* Movies released in 2010 (Slice) */
SELECT m.*, f.*, c.countryName, c.continentName, f.revenue - f.budget AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND d.year = 2010;

/**
2 Dice queries
**/

/* Movies released in 2010 that we're produced in the United States (Dice) */
SELECT m.*, f.*, d.year AS release_year, d.month AS release_month, d.day AS release_date, c.countryName, c.continentName, 
f.revenue - f.budget AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND d.year = 2010  AND c.countryName = 'United States of America';

/* Movies released in Europe that contain Comedy as a genre (Dice) */
SELECT m.*, f.*, d.year AS release_year, d.month AS release_month, d.day AS release_date, c.countryName, c.continentName, 
f.revenue - f.budget AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND c.continentName = 'Europe' AND m.genre LIKE '%Comedy%';

/**
4 Combinational queries (combination of any/all of the above)
**/

/* Total profit by year of films produced in the United Kingdom, sorted in descending order */
SELECT d.year As release_year, SUM(f.revenue) AS total_revenue, SUM(f.budget) AS total_budget, SUM(f.revenue - f.budget) as total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND c.countryName = 'United Kingdom'
GROUP BY release_year
ORDER BY total_profit DESC;

/* Total profit grouped by genre and year for films released in Canada */
SELECT m.genre, d.year, SUM(f.revenue) AS revenue, SUM(f.budget) AS budget, SUM(f.revenue - f.budget) AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND c.countryName = 'Canada'
GROUP BY genre, d.year
ORDER BY total_profit DESC;

/* Highest grossing actors who starred in films produced in North America */
SELECT p.name, SUM(f.revenue-f.budget) as total_profit
FROM MovieFactTable f, Movie m, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c, `ProductionStudio-Movie-bridgeTable` sb,
ProductionStudio s, `Actor-Movie-bridgeTable` ab, Person p
WHERE f.movie_id = m.movie_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id AND f.movie_id = sb.movie_id
AND sb.productionStudio_id = s.productionStudio_id AND f.movie_id = ab.movie_id AND ab.actor_id = p.person_id AND 
c.continentName = 'North America'
GROUP BY p.name
ORDER BY total_profit DESC;

/* Production Studio's total number of films and total profit made between 2000 to 2010 under the genre 'Action' */
SELECT s.companyName, COUNT(m.title) AS total_films_released, SUM(f.revenue) AS revenue, SUM(f.budget) AS budget, 
SUM(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `ProductionCountry-Movie-bridgeTable` cb, ProductionCountry c, 
`ProductionStudio-Movie-bridgeTable` sb, ProductionStudio s
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id AND f.movie_id = cb.movie_id AND cb.productionCountry_id = c.productionCountry_id
AND f.movie_id = sb.movie_id AND sb.productionStudio_id = s.productionStudio_id AND c.continentName = 'Asia' 
AND d.year >= 2000 AND d.year <= 2010 AND m.genre LIKE '%Action%'
GROUP BY s.companyName
ORDER BY total_profit DESC;

-----------------------------
-- PART 2 - Target: 3 Queries
-----------------------------

/**
Iceberg Queries
**/

/* Top 15 most profitable years */
SELECT d.year, SUM(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, ReleaseDate d
WHERE f.date_id = d.date_id
GROUP BY d.year
ORDER BY total_profit DESC
LIMIT 15;

/* Top 10 most profitable years for the Comedy genre */
SELECT d.year, SUM(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND m.genre LIKE '%Comedy%'
GROUP BY d.year
ORDER BY total_profit DESC
LIMIT 10;

/* Top 25 highest grossing actors between the years 2005 and 2015 */
SELECT p.name, SUM(f.revenue-f.budget) AS total_profit
FROM MovieFactTable f, Movie m, ReleaseDate d, `Actor-Movie-bridgeTable` ab, Person p
WHERE f.movie_id = m.movie_id AND f.date_id = d.date_id AND f.movie_id = ab.movie_id AND ab.actor_id = p.person_id
AND d.year >= 2005 AND d.year <= 2015
GROUP BY p.name
ORDER BY total_profit DESC
LIMIT 25;

/**
Windowing Query
**/

/* Comparing each movie's profit released by it's production studio and provides a rank */ 
SELECT s.companyName, m.title, (f.revenue-f.budget) AS total_profit, 
AVG(f.revenue-f.budget) OVER(PARTITION BY s.companyName) AS studio_avg_profit,
RANK() OVER (PARTITION BY s.companyName ORDER BY f.revenue - f.budget) AS profit_rank
FROM MovieFactTable f, Movie m, `ProductionStudio-Movie-bridgeTable` sb, ProductionStudio s
WHERE f.movie_id = m.movie_id AND f.movie_id = sb.movie_id AND sb.productionStudio_id = s.productionStudio_id;

/**
Window Clause
**/

/* Moving average of profit by production studio over time */
SELECT s.companyName, d.year, AVG(f.revenue - f.budget) OVER W AS company_moving_average
FROM MovieFactTable f, ReleaseDate d, `ProductionStudio-Movie-bridgeTable` sb, ProductionStudio s
WHERE f.date_id = d.date_id AND f.movie_id = sb.movie_id AND sb.productionStudio_id = s.productionStudio_id
WINDOW W AS (PARTITION BY s.companyName 
		ORDER BY d.year 
		RANGE BETWEEN 1 PRECEDING AND CURRENT ROW
);