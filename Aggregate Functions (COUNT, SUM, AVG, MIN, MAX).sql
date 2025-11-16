/*Aggregate functions perform calculations on multiple rows and return a single value.*/

/*COUNT(*) vs COUNT(column)**:
- COUNT(*) counts all rows (including NULLs)
- COUNT(column) counts only non-NULL values
✅ **Round averages** for cleaner output:

```sql
SELECT ROUND(AVG(age), 2) AS avg_age FROM patients;
```

✅ **Aggregates ignore NULL** (except COUNT(*))

✅ **Use DISTINCT with COUNT** to count unique values:*/



use sqlchallenge;

--1) Count the total number of patients in the hospital.
SELECT COUNT(NAME) FROM patients;

--2) Calculate the average satisfaction score of all patients.
SELECT AVG(SATISFACTION) FROM patients;

--3) Find the minimum and maximum age of patients.
SELECT MIN(AGE),MAX(AGE) FROM patients;

/*Calculate the total number of patients admitted,total patient refused
and average patient satisfaction across all services and weeks. 
Round the average satisfaction to 2 decimal places.*/
SELECT SUM(PATIENTS_ADMITTED)AS TOTAL_PATIENTS_ADMITTED ,
       SUM(PATIENTS_REFUSED) AS TOTAL_PATIENTS_REFUSED,
       ROUND(AVG(PATIENT_SATISFACTION),2)AS AVG_SATISFACTION 
 FROM SERVICES_WEEKLY;

