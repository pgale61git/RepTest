-- Ingres date tests
DROP TABLE IF EXISTS date_test
\p\g

CREATE TABLE date_test (
	the_key		INTEGER NOT NULL PRIMARY KEY,
	the_date	INGRESDATE NOT NULL,
	the_date_time	INGRESDATE NOT NULL,
	the_relative	INGRESDATE NOT NULL)
WITH JOURNALING
\p\g
