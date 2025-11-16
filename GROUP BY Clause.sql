/*GROUP BY divides rows into groups based on column values, then applies aggregate functions to each group.*/

/*Basic Syntax:
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1;*/

use sqlchallenge;

--1) Count the number of patients by each service.
 SELECT SERVICE ,COUNT (PATIENT_ID) AS PATIENT_COUNT
 FROM PATIENTS
 GROUP BY service;

 --2) Calculate the average age of patients grouped by service.
 SELECT SERVICE, AVG(AGE) AS AVG_AGE_OF_PATIENTS
 FROM patients
 GROUP BY SERVICE;

 --3) Find the total number of staff members per role.
 SELECT ROLE,COUNT(STAFF_ID) AS TOTAL_STAFF
 FROM staff
 GROUP BY role;

 /*For each hospital service, calculate total number of patient admitted,
 total patients refused,and the admission rate (percentage of the request
 that were admitted). Order by admission rate descending order*/

 SELECT SERVICE,SUM(PATIENTS_ADMITTED) AS TOTAL_PATIENTS_ADMITTED,
 SUM(PATIENTS_REFUSED) AS TOTAL_PATIENTS_REFUSED,
ROUND(SUM(PATIENTS_ADMITTED)*100/SUM(PATIENTS_REQUEST),2) AS ADMISSION_RATE
 FROM services_weekly
 GROUP BY SERVICE
 ORDER BY ADMISSION_RATE DESC;
