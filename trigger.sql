-- ТРІГЕР 
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








