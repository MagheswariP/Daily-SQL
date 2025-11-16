/*Date functions help you work with dates and times in SQL.*/

/*✅ **Date format matters**: Use ISO format ‘YYYY-MM-DD’ for consistency

✅ **Calculate date differences** using database-specific functions:

```sql
-- SQLite: JULIANDAY(date2) - JULIANDAY(date1)-- MySQL: DATEDIFF(date2, date1)-- PostgreSQL: date2 - date1
```

✅ **Extract parts with strftime** (SQLite):

```sql
strftime('%Y', date)  -- Year (2024)strftime('%m', date)  -- Month (01-12)strftime('%d', date)  -- Day (01-31)strftime('%W', date)  -- Week number
```

✅ **Use date functions in WHERE** carefully - they can slow queries on large tables

✅ **Always cast date calculations** to appropriate types (INTEGER, REAL) for consistency */


use sqlchallenge;

--1)Extract the year from all patient arrival dates.

SELECT NAME, DATEPART (YEAR, ARRIVAL_DATE) ARRIVAL_YEAR 
FROM patients;

--2)Calculate the length of stay for each patient (departure_date - arrival_date).

SELECT DATEDIFF (DAY,ARRIVAL_DATE, DEPARTURE_DATE) LENGTH_OF_STAY 
FROM patients;

--3)Find all patients who arrived in a specific month.

SELECT NAME, DATENAME (MONTH, ARRIVAL_DATE) ARRIVAL_MONTH
FROM patients
WHERE MONTH(ARRIVAL_DATE)= 11;

/*Calculate the average length of stay (in days) for each service, 
showing only services where the average stay is more than 7 days. 
Also show the count of patients and order by average stay descending.*/

SELECT SERVICE,
   AVG(DATEDIFF (DAY,ARRIVAL_DATE, DEPARTURE_DATE)) AVG_STAY,
   COUNT(NAME) PATIENT_COUNT
   FROM patients
GROUP BY SERVICE
HAVING AVG(DATEDIFF (DAY,ARRIVAL_DATE, DEPARTURE_DATE))  > 7 
ORDER BY AVG(DATEDIFF (DAY,ARRIVAL_DATE, DEPARTURE_DATE)) DESC;

