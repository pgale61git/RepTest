DROP TABLE IF EXISTS varbyte_test
\p\g
CREATE TABLE varbyte_test (
    id INTEGER NOT NULL,
    varbyte_col VARBYTE(200)
)
WITH JOURNALING
\p\g
ALTER TABLE varbyte_test ADD CONSTRAINT varbyte_test_pk PRIMARY KEY (id)
\p\g
