-- ФУНКЦІЯ
-- середня міцність пива по країні

DROP FUNCTION country_beer;

CREATE OR REPLACE FUNCTION country_beer(country text) 
RETURNS FLOAT
LANGUAGE 'plpgsql'
AS $$
   BEGIN
      RETURN  (SELECT SUM(info_abv) / COUNT(*)
               FROM place, info, beers
               WHERE beers.info_id = info.info_id 
               AND beers.place_id = place.place_id
               AND place_country = country
               AND info_abv IS NOT NULL
               GROUP BY place_country);           
   END;
$$

SELECT country_beer('US')