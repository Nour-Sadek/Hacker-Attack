/* 
Stage 1: School members

Create the person table and fill it with data from the person.csv file. 
This table contains teachers and students.
*/

/* Create the table  that will store the data
from the person.csv file */

CREATE TABLE "person"(
  "person_id" VARCHAR(9) PRIMARY KEY,
  "full_name" TEXT,
  "address" TEXT,
  "building_number" TEXT,
  "phone_number" TEXT
);

-- Import data from person.csv file
.mode csv
.import --skip 1 person.csv person
.mode column 

-- A simple query
SELECT person_id, 
       full_name
FROM person
ORDER BY person_id ASC
LIMIT 5;
