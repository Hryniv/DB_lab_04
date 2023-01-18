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


-- ПРОЦЕДУРА
-- додавання нового пива

DROP PROCEDURE new_beer;

CREATE OR REPLACE PROCEDURE new_beer(beer char(10), place_id INT, info_id INT)
LANGUAGE'plpgsql'
AS $$
   DECLARE 
      id place.place_id%type;
   BEGIN
      SELECT (beer_id+1) INTO id FROM beers ORDER BY beer_id DESC LIMIT 1;
      INSERT INTO Beers(beer_id, beer_name, place_id, info_id)
      VALUES(id, beer, place_id, info_id);
   END;
$$

CALL new_beer('super beer', 0, 0)
SELECT * FROM beers



-- ТРИГЕР 
-- При додаванні нового пива створювати таблицю з
-- його id, назвою пива, датою, іменем користувача

SELECT * from beers
SELECT * FROM beer_added

DROP TABLE IF EXISTS beer_added;
CREATE TABLE beer_added(
	id SERIAL PRIMARY KEY,
   beer_name char(100)  NOT NULL,
   update_date DATE NOT NULL,
   user_name varchar(50) NOT NULL
);

DROP TRIGGER IF EXISTS beers_update ON beers;
DROP FUNCTION IF EXISTS set_date CASCADE;

CREATE OR REPLACE FUNCTION set_date() RETURNS trigger 
LANGUAGE 'plpgsql'
AS $$
DECLARE
   id beers.beer_id%type := NEW.beer_id;
BEGIN
 	INSERT INTO beer_added(id, beer_name, update_date, user_name)
	VALUES(id, NEW.beer_name, now(), user);
	RETURN NULL;
END;
$$ ;

CREATE TRIGGER beers_update 
AFTER INSERT ON Beers
FOR EACH ROW EXECUTE FUNCTION set_date();


SELECT * from beers
SELECT * FROM beer_added

CALL new_beer('super beer 2', 0, 0)