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

/*
Stage 2: Who are you?

Your friend created another file. Now you know who the teachers are. 
First, create the teacher table from teacher.csv. 

Then compare the teacher table with the person table 
and find out who the students are.
*/

/* Create the table that will store the data 
from the teacher.csv file */

CREATE TABLE "teacher" (
    "person_id" VARCHAR(9) PRIMARY KEY,
    "class_code" TEXT
);

-- Import data from teacher.csv file
.mode csv
.import --skip 1 teacher.csv teacher
.mode column 

-- Query to select students from person table
CREATE VIEW stage_2_query AS
SELECT person_id, full_name
FROM person
WHERE person_id NOT IN (
    SELECT person_id
    FROM teacher
)
ORDER BY full_name ASC;

SELECT * from stage_2_query
LIMIT 5;

.print

-- Query to count number of students
SELECT COUNT(person_id)
FROM stage_2_query;