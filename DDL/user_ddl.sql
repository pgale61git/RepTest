-- rep_user does the replication
CREATE USER rep_user WITH PASSWORD='rep_user'
\p\g
ALTER USER rep_user WITH PRIVILEGES = (SECURITY)
\p\g
-- tbl_user owns the tables and does the workload
CREATE USER tbl_user WITH PASSWORD='tbl_user'
\p\g
