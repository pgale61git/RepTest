#!/bin/bash

# Insert dates

[[ "$1" != "" ]] && export II_TIMEZONE_NAME=$1

sql rep_s << !
INSERT INTO date_test VALUES 
	(1,'today','now','1 hour 27 minutes'),
	(2,'30-jun-61','31-dec-2025 23:59:59','1 year 2 months 3 days 4 hours 5 minutes 6 seconds')
\p\g
!

