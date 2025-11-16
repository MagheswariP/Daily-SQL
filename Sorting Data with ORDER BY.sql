/*ORDER BY sorts your query results based on one or more columns.*/

/*Basic Syntax:
SELECT column1, column2
FROM table_name
ORDER BY column1 [ASC|DESC];*/


use sqlchallenge;

--1) List all patients sorted by age in descending order.
SELECT * FROM patients
ORDER BY AGE DESC;

--2) Show all services_weekly data sorted by week number ascending and patients_request descending.
SELECT *FROM services_weekly
ORDER BY week ASC, PATIENTS_REQUEST DESC;

--3) Display staff members sorted alphabetically by their names.
SELECT STAFF_NAME  FROM STAFF
ORDER BY STAFF_NAME ASC;

/*Retrieve the top 5weeks with the highest patient refusals across all services,showing week,
service, patient_refused,and patient_reques. Sort by patient_refused by desecending order*/
SELECT TOP 5 WEEK, SERVICE,PATIENTS_REFUSED, PATIENTS_REQUEST FROM services_weekly
ORDER BY PATIENTS_REFUSED DESC;

