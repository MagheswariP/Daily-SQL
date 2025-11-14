create database sqlchallenge;

use sqlchallenge;

--DAY -10
--Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT NAME ,SATISFACTION,
CASE
   WHEN SATISFACTION >80 THEN 'HIGH'
   WHEN SATISFACTION >50 THEN 'MEDIUM'
   ELSE 'LOW'
END RATING
FROM patients;

--Label staff roles as 'Medical' or 'Support' based on role type.
SELECT STAFF_NAME, ROLE,
CASE
   WHEN ROLE ='DOCTOR' THEN 'MEDICAL'
   ELSE 'SUPPORT'
END ROLE_TYPE
FROM staff;

--Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT NAME, AGE,
CASE
   WHEN AGE BETWEEN 0 AND 18 THEN 'MINOR'
   WHEN AGE BETWEEN 19 AND 40 THEN 'MAJOR'
   WHEN AGE BETWEEN 41 AND 65 THEN 'ADULT'
   ELSE 'SENIOR PERSON' 
END AGE_GROUP
FROM PATIENTS;

/*Question: Create a service performance report showing service name, total patients admitted, 
and a performance category based on the following: 'Excellent' 
if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'.
Order by average satisfaction descending.*/

SELECT SERVICE, SUM(PATIENTS_ADMITTED) PATIENT_ADMITTED,
                AVG(PATIENT_SATISFACTION) PATIENT_SATISFACTION,
CASE
   WHEN AVG(PATIENT_SATISFACTION) >=85 THEN 'EXCELLENT'
   WHEN AVG(PATIENT_SATISFACTION) >=75 THEN 'GOOD'
   WHEN AVG(PATIENT_SATISFACTION) >= 65 THEN 'FAIR'
   ELSE 'NEED IMPROVEMENT'
END PERFORMANCE_CATEGORY
FROM services_weekly
GROUP BY SERVICE
ORDER BY AVG(PATIENT_SATISFACTION) DESC;


--List all unique services in the patients table.

SELECT DISTINCT SERVICE FROM patients;

--Find all unique staff roles in the hospital.

SELECT DISTINCT ROLE FROM staff;

--Get distinct months from the services_weekly table.

SELECT DISTINCT MONTH FROM services_weekly;

/*Question: Find all unique combinations of service 
and event type from the services_weekly table where events 
are not null or none, along with the count of occurrences for each combination. 
Order by count descending.*/

