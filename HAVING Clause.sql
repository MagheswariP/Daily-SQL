 use sqlchallenge

 /*HAVING filters groups created by GROUP BY, similar to how WHERE filters rows.*/

 /*Basic Syntax:
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1
HAVING aggregate_condition;*/

/*WHERE vs HAVING:
- WHERE: Filters rows before grouping
- HAVING: Filters groups after grouping
- WHERE: Cannot use aggregate functions
- HAVING: Can use aggregate functions*/
 
 
 
 --1)Find services that have admitted more than 500 patients in total.
SELECT SERVICE,SUM(PATIENTS_ADMITTED)AS TOTAL_PATIENTS_ADMITTED 
FROM services_weekly
GROUP BY service
HAVING SUM(PATIENTS_ADMITTED)>500;

--2)Show services where average patient satisfaction is below 75.
SELECT SERVICE, AVG(PATIENT_SATISFACTION)AS AVG_PATIENT_SATISFACTION
FROM services_weekly
GROUP BY service
HAVING AVG(PATIENT_SATISFACTION)<75;

SELECT SERVICE, AVG(PATIENT_SATISFACTION)AS AVG_PATIENT_SATISFACTION
FROM services_weekly
GROUP BY service

--3)List weeks where total staff presence across all services was less than 50.
SELECT WEEK , SUM(CAST (PRESENT AS INT))AS TOTAL_STAFF_PRESENTED
FROM staff_schedule
GROUP BY WEEK
HAVING SUM(CAST (PRESENT AS INT)) <50;

/* Identify services that refused more than 100 patients in total and had an 
average patient satisfaction below 80. Show service name, total refused, and average satisfaction.*/
SELECT SERVICE, SUM(PATIENTS_REFUSED)AS TOTAL_REFUSED,
AVG(PATIENT_SATISFACTION)AS AVERAGE_SATISFACTION
FROM services_weekly
GROUP BY SERVICE
HAVING SUM(PATIENTS_REFUSED)>100
AND AVG(PATIENT_SATISFACTION)<80
ORDER BY TOTAL_REFUSED DESC;