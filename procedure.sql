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