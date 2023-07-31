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
FROM 
    person
ORDER BY 
    person_id ASC
LIMIT 5;

.print

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
SELECT 
    person_id, 
    full_name
FROM 
    person
WHERE 
    person_id NOT IN (
        SELECT person_id
        FROM teacher
    )
ORDER BY 
    full_name ASC;

SELECT * FROM stage_2_query
LIMIT 5;

.print

-- Query to count number of students
SELECT COUNT(person_id)
FROM stage_2_query;

/*
Stage 3: You are a student

In the last stage, the students were listed. 
Now create the student table and fill it with data.
*/

-- Create student table

CREATE TABLE "student" (
    "person_id" VARCHAR(9) PRIMARY KEY,
    "grade_code" TEXT
);

-- Insert the students' person_id data to student table
INSERT INTO student (person_id)
SELECT person_id
FROM stage_2_query;

/* Select all columns from student table. 
Order the results by person_id ascending. 
Limit results to '5' */
SELECT * FROM student
ORDER BY person_id ASC
LIMIT 5;

/*
Stage 4: Plenty of files

Your friends created three more csv files score1.csv, score2.csv, anf score3.csv. 
These files contain the person_id of the students and the annual score. 
But, unfortunately, your friends didn't tell you the grade_code of the results. 
You need to find it out in the following steps.

Now, for this step, first create three temporary tables with the csv files. 
And then, with the union command, merge them all together.
*/

-- Create the three tables
CREATE TABLE "score1" (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

CREATE TABLE "score2" (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

CREATE TABLE "score3" (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

-- Import the data from the three csv files
.mode csv
.import --skip 1 score1.csv score1
.import --skip 1 score2.csv score2
.import --skip 1 score3.csv score3
.mode column

-- Merge data from the three score tables
CREATE VIEW merged_scores AS
SELECT * FROM score1
UNION ALL
SELECT * FROM score2
UNION ALL
SELECT * FROM score3;