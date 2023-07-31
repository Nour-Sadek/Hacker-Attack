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

/*
Stage 5: I know your score

create the score table. Insert the scores into the score table. 
When everything is done, delete score1, score2, and score3 tables with the DROP command.
*/

-- Create the score table
CREATE TABLE "score" (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

-- Insert the data from the three scores tables to score table
INSERT INTO score
SELECT * FROM merged_scores;

-- Delete the three score tables
DROP TABLE score1;
DROP TABLE score2;
DROP TABLE score3;

/* Select all columns from the score table. 
Order the results by person_id. 
Limit results to 5 */
SELECT * FROM score
ORDER BY person_id
LIMIT 5;

/* Select person_id, count(score) from the score table. 
Group by person_id. 
Having count(score) value 3 and order the results by person_id. 
Limit results to 5 */
SELECT 
    person_id, 
    count(score)
FROM 
    score
GROUP BY 
    person_id
HAVING 
    count(score) = 3
ORDER BY 
    person_id
LIMIT 5;

/*
Stage 6: Grade codes

You have the score table that contains the student's annual scores. But you don't know the students grade_code. 

However, you do know that:
    If there is no score in the score table, the grade code is GD-09;
    If the score count is 1 in the score table, the grade code is GD-10;
    If the score count is 2 in the score table, the grade code is GD-11;
    If the score count is 3 in the score table, the grade code will be GD-12.

With this information, fill in grade_code in the student table.
*/

-- Update grade_code to GD-09 when there is no score
UPDATE student
SET grade_code = 'GD-09'
WHERE student.person_id NOT IN
(SELECT person_id
FROM score);

-- Update grade_code to GD-10 when count(score) = 1
UPDATE student
SET grade_code = 'GD-10'
WHERE student.person_id in
(SELECT person_id
FROM (SELECT 
        person_id, 
        count(score)
    FROM 
        score
    GROUP BY 
        person_id
    HAVING 
        count(score) = 1)
);

-- Update grade_code to GD-11 when count(score) = 2
UPDATE student
SET grade_code = 'GD-11'
WHERE student.person_id in
(SELECT person_id
FROM (SELECT 
        person_id, 
        count(score)
    FROM 
        score
    GROUP BY 
        person_id
    HAVING 
        count(score) = 2)
);

-- Update grade_code to GD-12 when count(score) = 3
UPDATE student
SET grade_code = 'GD-12'
WHERE student.person_id in
(SELECT person_id
FROM (SELECT 
        person_id, 
        count(score)
    FROM 
        score
    GROUP BY 
        person_id
    HAVING 
        count(score) = 3)
);

/* Select all records from the student table, 
order by person_id, and limit by 5 */
SELECT * FROM student
ORDER BY person_id
LIMIT 5;