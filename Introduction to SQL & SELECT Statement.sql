/*SQL (Structured Query Language) is the standard language for managing relational databases. 
The SELECT statement is your primary tool for retrieving data.*/

/*Basic Syntax:
SELECT column1, column2, column3
FROM table_name;*/

use sqlchallenge;

--1) Retrieve all columns from the patients table.
SELECT * FROM patients;

--2) Select only the patient_id, name, and age columns from the patients table
SELECT PATIENT_ID,NAME,AGE FROM patients;

--3) Display the first 10 records from the services_weekly table.
SELECT TOP 10 * FROM services_weekly;

--List all unique hospital sevice availabe in the hospital.
SELECT DISTINCT SERVICE FROM services_weekly;
