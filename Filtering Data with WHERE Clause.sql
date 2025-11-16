/*The WHERE clause filters records based on conditions, returning only rows that meet your criteria.*/

/*Basic Syntax:
SELECT column1, column2
FROM table_name
WHERE condition;*/

use sqlchallenge;

--1) Find all patients who are older than 60 years.
SELECT * FROM patients
WHERE age > 60;

--2) Retrieve all staff members who work in the 'Emergency' service.
SELECT DISTINCT * FROM staff_schedule
WHERE service='EMERGENCY';

--3) List all weeks where more than 100 patients requested admission in any service.
SELECT DISTINCT WEEK FROM services_weekly
WHERE patients_request >100;

/*Find all patients admitted to 'surgery' service with a satisfaction score below 70,
Showing their patient_id,name,age,and satisfaction score.*/
SELECT PATIENT_ID,NAME,AGE, SATISFACTION  
FROM patients
WHERE SERVICE='SURGERY' AND SATISFACTION < 70;

